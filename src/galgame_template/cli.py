"""Command-line interface for phase-1 project generation."""

from __future__ import annotations

import argparse
from pathlib import Path
import sys

from .generator import generate_project
from .manifest import ManifestError


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(prog="galgame-template")
    subparsers = parser.add_subparsers(dest="command", required=True)

    generate_parser = subparsers.add_parser("generate", help="Generate a Ren'Py-style phase-1 project scaffold")
    generate_parser.add_argument("manifest_path", nargs="?", type=Path, help="Path to a project TOML manifest")
    generate_parser.add_argument("--manifest", dest="manifest_flag", type=Path, default=None)
    generate_parser.add_argument("--output-root", type=Path, default=None, help="Base directory for generated projects")
    generate_parser.add_argument("--force", action="store_true", help="Overwrite generated files if the target exists")

    return parser


def main(argv: list[str] | None = None) -> int:
    parser = build_parser()
    args = parser.parse_args(argv)

    if args.command == "generate":
        return _run_generate(args, parser)

    parser.error(f"Unsupported command: {args.command}")
    return 2


def _run_generate(args: argparse.Namespace, parser: argparse.ArgumentParser) -> int:
    manifest_path = args.manifest_flag or args.manifest_path
    if manifest_path is None:
        parser.error("generate requires either a positional manifest path or --manifest")

    try:
        generated_path = generate_project(manifest_path, args.output_root, force=args.force)
    except (ManifestError, FileExistsError, IsADirectoryError) as exc:
        print(f"error: {exc}", file=sys.stderr)
        return 2

    print(generated_path.resolve())
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
