from __future__ import annotations

from pathlib import Path
import sys
import tempfile
import unittest


ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "src"))

from galgame_template.generator import generate_project


class VerticalSliceSnapshotTests(unittest.TestCase):
    def test_prologue_contains_expected_vertical_slice_content(self) -> None:
        manifest_path = ROOT / "examples" / "minimal.project.toml"

        with tempfile.TemporaryDirectory() as temp_dir:
            project_root = generate_project(manifest_path, temp_dir)
            prologue = (project_root / "game" / "50_script_prologue.rpy").read_text(encoding="utf-8")
            bootstrap = (project_root / "game" / "00_bootstrap.rpy").read_text(encoding="utf-8")
            audio = (project_root / "game" / "20_audio.rpy").read_text(encoding="utf-8")
            transforms = (project_root / "game" / "30_transforms.rpy").read_text(encoding="utf-8")

        self.assertIn('label start:', prologue)
        self.assertIn('scene bg demo_room with bg_fade', prologue)
        self.assertIn('show char hero default at char_move_in_left', prologue)
        self.assertIn('safe_play_music("audio/music/demo_bgm.mp3", fadein=1.0)', prologue)
        self.assertIn('safe_play_voice("audio/voice/hero_001.wav")', prologue)
        self.assertIn('menu:', prologue)
        self.assertIn('label system_demo:', prologue)

        self.assertIn('default custom_auto_forward_seconds = 10.0', bootstrap)
        self.assertIn('default custom_seconds_per_char = 0.1', bootstrap)
        self.assertIn('default custom_text_cps = 10', bootstrap)

        self.assertIn('define audio.ui_click = "audio/sfx/ui_click.wav"', audio)
        self.assertIn('def safe_play_music(filename, fadein=0.0):', audio)
        self.assertIn('def safe_play_voice(filename):', audio)

        self.assertIn('define bg_fade = Dissolve(0.40)', transforms)
        self.assertIn('define bg_dissolve = Dissolve(0.25)', transforms)
        self.assertNotIn('transform bg_fade:', transforms)
        self.assertIn('transform char_move_in_left:', transforms)
        self.assertIn('transform char_shake:', transforms)
        self.assertIn('transform char_zoom_pulse:', transforms)
