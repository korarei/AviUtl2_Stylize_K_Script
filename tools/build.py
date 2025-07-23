import argparse
import io
import json
import shutil
import urllib.request
import zipfile
from pathlib import Path

import build_lib


def get_args():
    parser = argparse.ArgumentParser(description="AviUtl2 Script Builder")

    parser.add_argument(
        "--tag",
        default = "v0.1.0-dev",
        help = "Tag for the script version (default: v0.1.0-dev)"
    )

    return parser.parse_args()


def load_config(config_path: Path):
    try:
        with open(config_path, 'r', encoding="utf-8") as f:
            config = json.load(f)
        
        if "replacements_path" in config:
            config["replacements_path"] = {
                key: Path(value) for key, value in config["replacements_path"].items()
            }
    
        if "template_dir" in config:
            config["template_dir"] = Path(config["template_dir"])
    
        if "build_dir" in config:
            config["build_dir"] = Path(config["build_dir"])
    
        return config
    except FileNotFoundError:
        raise FileNotFoundError(f"Config file not found: {config_path}")
    except json.JSONDecodeError as e:
        raise ValueError(f"Invalid JSON format: {e}")


def get_data(zip_url: str, extract_dir: Path):
    extract_dir.mkdir(parents=True, exist_ok=True)

    with urllib.request.urlopen(zip_url) as response:
        zip_data = response.read()
    
    with zipfile.ZipFile(io.BytesIO(zip_data)) as zip_ref:
        zip_ref.extractall(extract_dir)


def create_txt(dst: Path, filename: str, content: str):
    dst.mkdir(parents=True, exist_ok=True)
    file_path = dst / filename
    file_path.write_text(content, encoding="utf-8")


def main():
    args = get_args()
    tools_dir = Path(__file__).parent
    root_dir = (tools_dir / "..").resolve()

    config_path = tools_dir / "build_config.json"
    config = load_config(config_path)

    build_dir = root_dir / config["build_dir"]
    if build_dir.exists() and build_dir.is_dir():
        shutil.rmtree(build_dir)

    publish_dir = build_dir / "publish"
    script_path = publish_dir / (config["script_name"] + ".anm2")

    template_path = root_dir / config["template_dir"] / (config["script_name"] + "_template.anm2")
    replacements = config["replacements_path"]
    replacements.update({
        "LABEL": config["label"],
        "SCRIPT_NAME": config["script_name"],
        "VERSION": args.tag
    })

    build_lib.build_script(template_path, replacements, script_path)
    build_lib.copy_docs(root_dir, publish_dir)
    build_lib.create_release_note(root_dir, build_dir)

    map_dir = publish_dir / "map_data"
    get_data("https://drive.usercontent.google.com/u/0/uc?id=1hk6XHRxzFkjobc1wOHtsPDyAwKjvkWHB&export=download", map_dir)
    create_txt(map_dir, "credits.txt", "グラデーション画像提供者: ゼットデジタ 様")

    build_lib.create_zip(publish_dir, build_dir, config["script_name"])


if __name__ == "__main__":
    main()
