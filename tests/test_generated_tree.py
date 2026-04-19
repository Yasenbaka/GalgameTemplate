from __future__ import annotations

from pathlib import Path
import sys
import tempfile
import unittest


ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "src"))

from galgame_template.generator import generate_project


EXPECTED_FILES = {
    Path("game/options.rpy"),
    Path("game/gui.rpy"),
    Path("game/00_bootstrap.rpy"),
    Path("game/10_characters.rpy"),
    Path("game/20_audio.rpy"),
    Path("game/30_transforms.rpy"),
    Path("game/40_screens_main_menu.rpy"),
    Path("game/41_screens_hud.rpy"),
    Path("game/42_screens_save_load.rpy"),
    Path("game/43_screens_preferences.rpy"),
    Path("game/44_screens_history.rpy"),
    Path("game/45_screens_confirm.rpy"),
    Path("game/50_script_prologue.rpy"),
    Path("game/images/backgrounds/.gitkeep"),
    Path("game/images/characters/.gitkeep"),
    Path("game/audio/music/.gitkeep"),
    Path("game/audio/sfx/.gitkeep"),
    Path("game/audio/voice/.gitkeep"),
}


class GeneratedTreeTests(unittest.TestCase):
    def test_generator_outputs_expected_project_tree(self) -> None:
        manifest_path = ROOT / "examples" / "minimal.project.toml"

        with tempfile.TemporaryDirectory() as temp_dir:
            project_root = generate_project(manifest_path, temp_dir)
            actual_files = {
                path.relative_to(project_root)
                for path in project_root.rglob("*")
                if path.is_file()
            }

        self.assertTrue(EXPECTED_FILES.issubset(actual_files))
