"""Filesystem generation orchestration for phase-1 output."""

from __future__ import annotations

from pathlib import Path

from .constants import DEFAULT_OUTPUT_ROOT_NAME
from .manifest import ProjectManifest, load_manifest
from .render import build_render_plan, write_render_plan


def generate_project(
    manifest: ProjectManifest | str | Path,
    output_root: str | Path | None = None,
    *,
    force: bool = False,
) -> Path:
    resolved_manifest = load_manifest(manifest) if isinstance(manifest, (str, Path)) else manifest
    resolved_output_root = Path(output_root) if output_root is not None else Path.cwd() / DEFAULT_OUTPUT_ROOT_NAME
    resolved_output_root.mkdir(parents=True, exist_ok=True)

    project_root = resolved_output_root / resolved_manifest.project.slug
    if project_root.exists() and any(project_root.iterdir()) and not force:
        raise FileExistsError(
            f"Output directory already exists and is not empty: {project_root}. Use --force to overwrite generated files."
        )

    project_root.mkdir(parents=True, exist_ok=True)
    write_render_plan(project_root, build_render_plan(resolved_manifest), force=force)
    return project_root
