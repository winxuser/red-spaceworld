
#!/usr/bin/env python3
from pathlib import Path
from PIL import Image
import re

ICON_DIR = Path("gfx/icons/custom")
CONSTANTS_FILE = Path("constants/pokemon_constants.asm")

BANK_A = Path("gfx/icons/custom_icons_a.asm")
BANK_B = Path("gfx/icons/custom_icons_b.asm")
POINTERS = Path("data/pokemon/custom_icon_pointers.asm")

# Read valid internal Pokemon species constants.
constants = set(re.findall(
    r"^\s*const\s+([A-Z][A-Z0-9_]*)\b",
    CONSTANTS_FILE.read_text(),
    re.MULTILINE
))

icons = sorted(ICON_DIR.glob("*.png"))
entries = []

for png in icons:
    species = png.stem.upper()

    if species not in constants:
        raise ValueError(f"Unknown species: {png.name}")

    with Image.open(png) as image:
        if image.size != (16, 32):
            raise ValueError(
                f"Invalid dimensions: {png.name} {image.size}"
            )

    label = f"Custom{species.title().replace('_', '')}Icon"
    entries.append((species, label, png.with_suffix(".2bpp")))

# 128 bytes per icon; 151 icons split across two banks.
half = (len(entries) + 1) // 2

if half * 128 > 16384:
    raise ValueError("Too many icons for two ROM banks")

def write_bank(path, entries):
    lines = [
        "; Automatically generated custom party icon graphics",
        "; Do not edit manually.",
        "",
    ]

    for species, label, binary in entries:
        lines.extend([
            f"{label}::",
            f'    INCBIN "{binary.as_posix()}"',
            "",
        ])

    path.write_text("\n".join(lines))

write_bank(BANK_A, entries[:half])
write_bank(BANK_B, entries[half:])

lines = [
    "; Automatically generated custom party icon pointers",
    "; Do not edit manually.",
    "",
    "CustomPartyIconPointers::",
]

for species, label, binary in entries:
    lines.extend([
        f"    db {species}",
        f"    db BANK({label})",
        f"    dw {label}",
        "",
    ])

lines.append("    db $ff ; end of table")
POINTERS.write_text("\n".join(lines) + "\n")

print(f"Custom icons registered: {len(entries)}")
print(f"Bank $7D: {len(entries[:half])} icons")
print(f"Bank $7E: {len(entries[half:])} icons")
print("Generated graphics and pointer tables.")
