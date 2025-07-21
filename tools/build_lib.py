import os
import re
import shutil
import zipfile
from pathlib import Path


def build_script(template_path: Path, replacements: dict[str, str | Path], output_path: Path):
    try:
        content = template_path.read_text(encoding="utf-8")
        pattern = r"\$\{([a-zA-Z0-9_]+)\}"

        def replacer(match: re.Match[str]) -> str:
            key = match.group(1)
            val = replacements.get(key)

            if val is None:
                return match.group(0)
            
            if isinstance(val, Path):
                if (val.exists()):
                    return val.read_text(encoding="utf-8")
                else:
                    return match.group(0)
            else:
                return str(val)

        updated_content = re.sub(pattern, replacer, content)

        output_path.parent.mkdir(exist_ok=True, parents=True)
        output_path.write_text(updated_content, encoding="utf-8")

    except FileNotFoundError as e:
        print(f"Error: {e}")
    except Exception as e:
        print(f"An unexpected error occurred: {e}")


def copy_docs(src_dir: Path, dst_dir: Path):
    readme = src_dir / "README.md"
    license = src_dir / "LICENSE"

    if readme.exists():
        shutil.copy2(readme, dst_dir)

    if license.exists():
        shutil.copy2(license, dst_dir)


def create_release_note(readme_dir: Path, output_dir: Path):
    readme_path = readme_dir / "README.md"
    if not readme_path.exists():
        return

    try:
        lines = readme_path.read_text(encoding="utf-8").splitlines()
    except Exception as e:
        raise RuntimeError(f"Failed to read {readme_path}: {e}")

    try:
        start_index = next(i for i, line in enumerate(lines) if line.strip() == "## Change Log")
    except StopIteration:
        raise ValueError("Missing required section: '## Change Log'")

    lines = lines[start_index + 1:]

    version_header_pattern = re.compile(r"- \*\*(v[\d.]+)\*\*")
    change_line_pattern = re.compile(r"^\s*-\s(.+)")

    changes: list[str] = []
    found_version = False
    for line in lines:
        if version_header_pattern.match(line):
            if found_version:
                break
            found_version = True
            continue

        if found_version:
            match = change_line_pattern.match(line)
            if match:
                changes.append(f"- {match.group(1).strip()}")

    if not changes:
        return

    content = "## What's Changed\n" + "\n".join(changes) + "\n"
    output_path = output_dir / "release_note.txt"
    output_path.write_text(content, encoding="utf-8")


def create_zip(src_dir: Path, output_dir: Path, zip_name: str, root_name: str | None = None):
    if root_name is None:
        root_name = zip_name
    
    zip_path = output_dir / (zip_name + ".zip")

    with zipfile.ZipFile(zip_path, 'w', zipfile.ZIP_DEFLATED) as zipf:
        for root, _, files in os.walk(src_dir):
            root_path = Path(root)
            rel_path = root_path.relative_to(src_dir)

            if rel_path == Path('.'):
                arc_path = Path(root_name)
            else:
                arc_path = Path(root_name) / rel_path

            for file in files:
                file_path = root_path / file
                arc_file_path = arc_path / file
                zipf.write(file_path, arc_file_path.as_posix())
