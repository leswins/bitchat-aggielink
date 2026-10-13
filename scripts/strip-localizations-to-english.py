#!/usr/bin/env python3
"""Keep English string-catalog entries and rename visible bitchat copy.

Aggie Link ships one language. Other locales are removed so a partial
translation cannot show upstream bitchat wording. The bitchat:// URL scheme
is preserved because it is the wire deep link, not a product name.
"""

from __future__ import annotations

import json
import re
import sys
from pathlib import Path

TOKEN = "\ue000URLSCHEME\ue001"
HELP_KEY = "command.help.text"
HELP_VALUE = (
    "commands:\n"
    "/msg @name [message] — start a private chat\n"
    "/who — list who's here\n"
    "/clear — clear this chat\n"
    "/hug @name — send a hug\n"
    "/slap @name — slap with a large trout\n"
    "/block @name · /unblock @name\n"
    "/fav @name · /unfav @name — favorites\n"
    "/group create <name> — start an encrypted group\n"
    "/group invite @name · /group remove @name — manage members (creator)\n"
    "/group leave · /group list — leave or list your groups\n"
    "/ping @name — measure round-trip time\n"
    "/trace @name — estimated mesh path\n"
    "/help — this list"
)

ROOT = Path(__file__).resolve().parents[1]
CATALOGS = [
    ROOT / "bitchat" / "Localizable.xcstrings",
    ROOT / "bitchatShareExtension" / "Localization" / "Localizable.xcstrings",
]


def rename_product(value: str) -> str:
    protected = value.replace("bitchat://", TOKEN)
    # "bitchatters" is the nearby-notification nickname, not the product name.
    renamed = re.sub(r"bitchatters", "Aggies", protected, flags=re.IGNORECASE)
    renamed = renamed.replace("bitchat/", "aggie/")
    renamed = re.sub(r"bitchat", "Aggie Link", renamed, flags=re.IGNORECASE)
    return renamed.replace(TOKEN, "bitchat://")


def rewrite_units(node: object) -> None:
    if isinstance(node, dict):
        unit = node.get("stringUnit")
        if isinstance(unit, dict) and isinstance(unit.get("value"), str):
            unit["value"] = rename_product(unit["value"])
        for child in node.values():
            rewrite_units(child)
    elif isinstance(node, list):
        for child in node:
            rewrite_units(child)


def strip_catalog(path: Path) -> None:
    data = json.loads(path.read_text(encoding="utf-8"))
    missing_english = []
    for key, entry in data.get("strings", {}).items():
        if not isinstance(entry, dict):
            continue
        localizations = entry.get("localizations") or {}
        english = localizations.get("en")
        if english is None:
            if entry.get("shouldTranslate") is False or not localizations:
                entry["localizations"] = {}
            else:
                missing_english.append(key)
                entry["localizations"] = {}
            continue
        rewrite_units(english)
        if key == HELP_KEY:
            unit = english.get("stringUnit")
            if isinstance(unit, dict):
                unit["value"] = HELP_VALUE
        entry["localizations"] = {"en": english}
    path.write_text(json.dumps(data, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(f"{path.relative_to(ROOT)}: english only")
    if missing_english:
        print("  keys without an English value:", ", ".join(missing_english), file=sys.stderr)


def main() -> None:
    for path in CATALOGS:
        strip_catalog(path)


if __name__ == "__main__":
    main()
