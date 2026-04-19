"""Filesystem generation orchestration for phase-1 output."""

from __future__ import annotations

import shutil
import sys
from pathlib import Path

from .constants import DEFAULT_OUTPUT_ROOT_NAME
from .manifest import ProjectManifest, load_manifest
from .render import build_render_plan, write_render_plan


# Priority list of system CJK fonts to auto-copy into the generated project.
_FONT_CANDIDATES: list[tuple[str, ...]] = [
    # Windows
    (r"C:\Windows\Fonts\msyh.ttc",),          # Microsoft YaHei
    (r"C:\Windows\Fonts\msyhbd.ttc",),        # Microsoft YaHei Bold
    (r"C:\Windows\Fonts\simsun.ttc",),        # SimSun
    # macOS
    ("/System/Library/Fonts/PingFang.ttc",),
    ("/System/Library/Fonts/STHeiti Light.ttc",),
    ("/Library/Fonts/Arial Unicode.ttf",),
    # Linux / common distributions
    ("/usr/share/fonts/truetype/wqy/wqy-zenhei.ttc",),
    ("/usr/share/fonts/opentype/noto/NotoSansCJKsc-Regular.otf",),
    ("/usr/share/fonts/noto-cjk/NotoSansCJKsc-Regular.otf",),
]


def _find_system_cjk_font() -> Path | None:
    """Return the first existing system CJK font path, or None."""
    for candidates in _FONT_CANDIDATES:
        for candidate in candidates:
            path = Path(candidate)
            if path.exists():
                return path
    return None


def _copy_fonts(project_root: Path) -> None:
    """Copy a system CJK font into the generated project's game/fonts/ directory."""
    fonts_dir = project_root / "game" / "fonts"
    fonts_dir.mkdir(parents=True, exist_ok=True)

    font_source = _find_system_cjk_font()
    if font_source is None:
        print(
            "warning: No system CJK font found. The generated project may display boxes "
            "for Chinese characters. Please manually copy a Chinese font (e.g. msyh.ttc, "
            "NotoSansCJKsc-Regular.otf) into {fonts_dir}.",
            file=sys.stderr,
        )
        return

    font_dest = fonts_dir / font_source.name
    shutil.copy2(font_source, font_dest)
    print(f"Copied system font: {font_source} -> {font_dest}")


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
    _copy_fonts(project_root)
    return project_root
