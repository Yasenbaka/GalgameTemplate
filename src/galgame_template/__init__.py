"""Public package exports for the phase-1 scaffold generator."""

from .constants import __version__
from .generator import generate_project
from .manifest import ManifestError, ProjectConfig, ProjectManifest, UIConfig, load_manifest

__all__ = [
    "__version__",
    "ManifestError",
    "ProjectConfig",
    "ProjectManifest",
    "UIConfig",
    "generate_project",
    "load_manifest",
]
