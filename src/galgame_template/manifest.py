"""Manifest loading and validation for phase-1 generation."""

from __future__ import annotations

from dataclasses import dataclass
from pathlib import Path
import re
import tomllib


class ManifestError(ValueError):
    """Raised when the manifest is missing required data or violates the contract."""


def _require_positive_number(name: str, value: object) -> float:
    if isinstance(value, bool) or not isinstance(value, (int, float)):
        raise ManifestError(f"{name} must be a number, got {type(value).__name__}.")

    numeric = float(value)
    if numeric <= 0:
        raise ManifestError(f"{name} must be greater than 0, got {numeric}.")

    return numeric


def _require_positive_int(name: str, value: object) -> int:
    numeric = _require_positive_number(name, value)
    if int(numeric) != numeric:
        raise ManifestError(f"{name} must be an integer, got {numeric}.")

    return int(numeric)


def _sanitize_project_name(name: str) -> str:
    sanitized = re.sub(r"[^A-Za-z0-9._-]+", "_", name).strip("._-")
    return sanitized or "project"


@dataclass(frozen=True, slots=True)
class ProjectConfig:
    name: str
    version: str
    window_title: str

    @property
    def slug(self) -> str:
        return _sanitize_project_name(self.name)


@dataclass(frozen=True, slots=True)
class UIConfig:
    save_pages: int
    slots_per_page: int
    default_auto_forward_seconds: float
    default_seconds_per_char: float
    history_length: int

    @property
    def save_slot_count(self) -> int:
        return self.save_pages * self.slots_per_page

    @property
    def default_text_cps(self) -> int:
        return max(1, int(round(1.0 / self.default_seconds_per_char)))


@dataclass(frozen=True, slots=True)
class ProjectManifest:
    project: ProjectConfig
    ui: UIConfig
    source_path: Path | None = None


def load_manifest(path: str | Path) -> ProjectManifest:
    manifest_path = Path(path)
    if not manifest_path.exists():
        raise ManifestError(f"Manifest file does not exist: {manifest_path}")

    with manifest_path.open("rb") as handle:
        raw = tomllib.load(handle)

    project_section = raw.get("project")
    ui_section = raw.get("ui")
    if not isinstance(project_section, dict):
        raise ManifestError("Manifest must contain a [project] table.")
    if not isinstance(ui_section, dict):
        raise ManifestError("Manifest must contain a [ui] table.")

    name = _require_non_empty_string("project.name", project_section.get("name"))
    version = _require_non_empty_string("project.version", project_section.get("version", "0.1.0"))
    window_title = _require_non_empty_string(
        "project.window_title",
        project_section.get("window_title", name),
    )

    project = ProjectConfig(name=name, version=version, window_title=window_title)
    ui = UIConfig(
        save_pages=_require_positive_int("ui.save_pages", ui_section.get("save_pages")),
        slots_per_page=_require_positive_int("ui.slots_per_page", ui_section.get("slots_per_page")),
        default_auto_forward_seconds=_require_positive_number(
            "ui.default_auto_forward_seconds",
            ui_section.get("default_auto_forward_seconds"),
        ),
        default_seconds_per_char=_require_positive_number(
            "ui.default_seconds_per_char",
            ui_section.get("default_seconds_per_char"),
        ),
        history_length=_require_positive_int("ui.history_length", ui_section.get("history_length")),
    )

    return ProjectManifest(project=project, ui=ui, source_path=manifest_path.resolve())


def _require_non_empty_string(name: str, value: object) -> str:
    if not isinstance(value, str) or not value.strip():
        raise ManifestError(f"{name} must be a non-empty string.")

    return value.strip()
