"""Shared constants for the phase-1 scaffold generator."""

from pathlib import Path

__version__ = "0.1.0"

PACKAGE_NAME = "galgame_template"
SUPPORTED_TEMPLATE = "renpy"
DEFAULT_OUTPUT_ROOT_NAME = "out"
FUTURE_TEMPLATE_ROOT = Path("templates") / SUPPORTED_TEMPLATE / "game"
GENERATED_README_NAME = "README.generated.md"

ASSET_DIRECTORIES = (
    Path("game/images/backgrounds"),
    Path("game/images/characters"),
    Path("game/images/ui"),
    Path("game/audio/music"),
    Path("game/audio/sfx"),
    Path("game/audio/voice"),
)
