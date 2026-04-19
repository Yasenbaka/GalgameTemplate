from __future__ import annotations

from pathlib import Path
import sys
import tempfile
import unittest


ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "src"))

from galgame_template.manifest import load_manifest


class ManifestTests(unittest.TestCase):
    def test_load_manifest_reads_expected_fields(self) -> None:
        manifest = load_manifest(ROOT / "examples" / "minimal.project.toml")

        self.assertEqual(manifest.project.name, "Phase1Demo")
        self.assertEqual(manifest.project.slug, "Phase1Demo")
        self.assertEqual(manifest.ui.save_pages, 5)
        self.assertEqual(manifest.ui.slots_per_page, 10)
        self.assertEqual(manifest.ui.save_slot_count, 50)
        self.assertEqual(manifest.ui.default_text_cps, 10)

    def test_load_manifest_rejects_invalid_values(self) -> None:
        invalid_content = """
[project]
name = "Broken"
version = "0.1.0"
window_title = "Broken"

[ui]
save_pages = 0
slots_per_page = 10
default_auto_forward_seconds = 10.0
default_seconds_per_char = 0.1
history_length = 250
"""

        with tempfile.TemporaryDirectory() as temp_dir:
            manifest_path = Path(temp_dir) / "broken.toml"
            manifest_path.write_text(invalid_content.strip(), encoding="utf-8")

            with self.assertRaises(ValueError):
                load_manifest(manifest_path)
