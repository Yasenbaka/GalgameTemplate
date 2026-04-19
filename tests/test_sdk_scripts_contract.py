from __future__ import annotations

from pathlib import Path
import unittest


ROOT = Path(__file__).resolve().parents[1]


class SdkScriptContractTests(unittest.TestCase):
    def test_sdk_scripts_require_environment_variable_and_expected_commands(self) -> None:
        lint_script = (ROOT / "scripts" / "lint_with_sdk.ps1").read_text(encoding="utf-8")
        build_script = (ROOT / "scripts" / "build_windows.ps1").read_text(encoding="utf-8")
        generate_script = (ROOT / "scripts" / "generate.ps1").read_text(encoding="utf-8")
        run_script = (ROOT / "scripts" / "run_with_sdk.ps1").read_text(encoding="utf-8")
        batch_launcher = (ROOT / "双击启动预览.bat").read_text(encoding="utf-8")

        self.assertIn('RENPY_SDK_PATH', lint_script)
        self.assertIn('renpy.py', lint_script)
        self.assertIn(' lint', lint_script)

        self.assertIn('RENPY_SDK_PATH', build_script)
        self.assertIn('launcher distribute', build_script)
        self.assertIn('--package $Package --no-update', build_script)

        self.assertIn('python -m galgame_template.cli generate', generate_script)
        self.assertIn('$env:PYTHONPATH', generate_script)

        self.assertIn('RENPY_SDK_PATH', run_script)
        self.assertIn('renpy.py', run_script)
        self.assertIn('out/Phase1Demo', run_script)
        self.assertIn('generate.ps1', run_script)
        self.assertIn('examples/minimal.project.toml', run_script)
        self.assertIn('renpy-sdk-path.txt', run_script)
        self.assertIn('renpy-sdk-path.example.txt', run_script)
        self.assertIn('Unable to locate a Ren\'Py SDK automatically', run_script)
        self.assertIn('$PythonExe $RenpyPy $ResolvedProjectPath run', run_script)
        self.assertIn('For non-default projects, generate it first', run_script)

        self.assertIn('scripts\\run_with_sdk.ps1', batch_launcher)
        self.assertIn('renpy-sdk-path.txt', batch_launcher)
        self.assertIn('pause', batch_launcher)

    def test_readme_documents_local_sdk_setup_and_double_click_flow(self) -> None:
        readme = (ROOT / "README.md").read_text(encoding="utf-8")
        gitignore = (ROOT / ".gitignore").read_text(encoding="utf-8")
        example_sdk_path = (ROOT / "renpy-sdk-path.example.txt").read_text(encoding="utf-8")

        self.assertIn('双击启动预览.bat', readme)
        self.assertIn('scripts/run_with_sdk.ps1', readme)
        self.assertIn('scripts/generate.ps1', readme)
        self.assertIn('renpy-sdk-path.txt', readme)
        self.assertIn('renpy-sdk-path.example.txt', readme)
        self.assertIn('.gitignore', readme)
        self.assertIn('不应该提交到仓库', readme)
        self.assertIn('RENPY_SDK_PATH', readme)
        self.assertIn('lint_with_sdk.ps1', readme)
        self.assertIn('build_windows.ps1', readme)

        self.assertIn('renpy-sdk-path.txt', gitignore)
        self.assertEqual(example_sdk_path.strip(), r'D:\path\to\renpy-8.5.2-sdk')
