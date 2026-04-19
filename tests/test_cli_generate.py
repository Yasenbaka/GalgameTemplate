from __future__ import annotations

from io import StringIO
from pathlib import Path
import contextlib
import sys
import tempfile
import unittest


ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "src"))

from galgame_template.cli import main


class CliGenerateTests(unittest.TestCase):
    def test_generate_command_creates_project_and_prints_path(self) -> None:
        manifest_path = ROOT / "examples" / "minimal.project.toml"

        with tempfile.TemporaryDirectory() as temp_dir:
            stdout = StringIO()

            with contextlib.redirect_stdout(stdout):
                exit_code = main(
                    [
                        "generate",
                        str(manifest_path),
                        "--output-root",
                        temp_dir,
                    ]
                )

            generated_path = Path(stdout.getvalue().strip())
            self.assertEqual(exit_code, 0)
            self.assertTrue(generated_path.exists())
            self.assertTrue((generated_path / "game" / "options.rpy").exists())
