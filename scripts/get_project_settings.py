#!/usr/bin/env python3
"""
Home Assistant Plugin Template - Project Settings Reader

This script reads project settings from scripts/init.json and provides
them as environment variables for use in other scripts.

Usage:
    source <(python3 scripts/get_project_settings.py)

Or in a script:
    eval "$(python3 scripts/get_project_settings.py)"

If scripts/init.json is missing, it will error out with a hint to run init.sh first.
"""

import json
import os
import sys

def main():
    settings_file = "scripts/init.json"

    if not os.path.exists(settings_file):
        print("Error: scripts/init.json not found!", file=sys.stderr)
        print("Please run 'make init' or './scripts/init.sh' first to initialize the project.", file=sys.stderr)
        sys.exit(1)

    try:
        with open(settings_file, 'r') as f:
            settings = json.load(f)
    except json.JSONDecodeError as e:
        print(f"Error: Invalid JSON in {settings_file}: {e}", file=sys.stderr)
        sys.exit(1)
    except Exception as e:
        print(f"Error reading {settings_file}: {e}", file=sys.stderr)
        sys.exit(1)

    # Output environment variable assignments
    print(f"export DISPLAY_NAME='{settings['display_name']}'")
    print(f"export DASH_NAME='{settings['dash_name']}'")
    print(f"export SNAKE_NAME='{settings['snake_name']}'")
    print(f"export PASCAL_NAME='{settings['pascal_name']}'")
    print(f"export GITHUB_USER='{settings['github_user']}'")
    print(f"export GITHUB_URL='{settings['github_url']}'")
    print(f"export KEEP_BACKEND={str(settings['keep_backend']).lower()}")
    print(f"export FRONTEND_CHOICE='{settings['frontend_choice']}'")
    print(f"export CURRENT_YEAR={settings['current_year']}")

if __name__ == "__main__":
    main()
