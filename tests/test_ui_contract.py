from __future__ import annotations

from pathlib import Path
import sys
import tempfile
import unittest


ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "src"))

from galgame_template.generator import generate_project


class UiContractTests(unittest.TestCase):
    def test_generated_files_contain_required_runtime_hooks(self) -> None:
        manifest_path = ROOT / "examples" / "minimal.project.toml"

        with tempfile.TemporaryDirectory() as temp_dir:
            project_root = generate_project(manifest_path, temp_dir)

            main_menu = (project_root / "game" / "40_screens_main_menu.rpy").read_text(encoding="utf-8")
            hud = (project_root / "game" / "41_screens_hud.rpy").read_text(encoding="utf-8")
            save_load = (project_root / "game" / "42_screens_save_load.rpy").read_text(encoding="utf-8")
            preferences = (project_root / "game" / "43_screens_preferences.rpy").read_text(encoding="utf-8")
            history = (project_root / "game" / "44_screens_history.rpy").read_text(encoding="utf-8")
            confirm = (project_root / "game" / "45_screens_confirm.rpy").read_text(encoding="utf-8")

        self.assertIn('screen main_menu():', main_menu)
        self.assertIn('imagebutton', main_menu)
        self.assertIn('images/ui/start_game.png', main_menu)
        self.assertIn('images/ui/load_game.png', main_menu)
        self.assertIn('images/ui/settings.png', main_menu)
        self.assertIn('images/ui/exit_game.png', main_menu)

        self.assertIn('key "mouseup_3" action Function(toggle_interface)', hud)
        self.assertIn('imagebutton', hud)
        self.assertIn('images/ui/SAVE.png', hud)
        self.assertIn('images/ui/LOAD.png', hud)
        self.assertIn('images/ui/config.png', hud)
        self.assertIn('images/ui/EXIT.png', hud)
        self.assertIn('images/ui/history.png', hud)
        self.assertIn('images/ui/auto.png', hud)
        self.assertIn('images/ui/pause.png', hud)
        self.assertIn('yalign 1.0', hud)

        self.assertIn('screen save():', save_load)
        self.assertIn('screen load():', save_load)
        self.assertIn('screen file_slot_grid(mode):', save_load)
        self.assertIn('Overwrite', confirm)
        self.assertIn('Function(save_or_confirm, slot_name)', save_load)

        self.assertIn('Preference("music volume")', preferences)
        self.assertIn('Preference("voice volume")', preferences)
        self.assertIn('Preference("sound volume")', preferences)
        self.assertIn('VariableValue("custom_auto_forward_seconds"', preferences)
        self.assertIn('VariableValue("custom_seconds_per_char"', preferences)
        self.assertIn('Function(set_auto_forward_seconds, custom_auto_forward_seconds)', preferences)
        self.assertIn('Function(set_text_seconds_per_char, custom_seconds_per_char)', preferences)

        self.assertIn('screen history_log():', history)
        self.assertIn('_history_list', history)
        self.assertIn('scrollbars "vertical"', history)

        self.assertIn('screen confirm_exit():', confirm)
        self.assertIn('screen confirm_save_overwrite(slot_name):', confirm)
