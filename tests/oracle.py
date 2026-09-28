#!/usr/bin/env python3
"""Oracle: run vectors through the TRUE normalize_art, save expected."""
import sys
from pathlib import Path

sys.path.insert(0, str(Path.home() / "bin"))
import importlib.machinery
import importlib.util

loader = importlib.machinery.SourceFileLoader(
    "fae_imp_oracle", str(Path.home() / "bin" / "imp")
)
spec = importlib.util.spec_from_loader(loader.name, loader)
mod = importlib.util.module_from_spec(spec)
sys.modules[loader.name] = mod
spec.loader.exec_module(mod)

V = Path.home() / "imp" / "tests" / "vectors"
V.mkdir(parents=True, exist_ok=True)

ESC = "\x1b"
C0_IN = "ab\x00c\x07d"
MUSHROOM = (
    f"{ESC}[38;5;175m╭─ ✦ a moonlit mushroom ✦ ─╮{ESC}[0m\n"
    f"{ESC}[38;5;220m    \U0001f344{ESC}[0m{ESC}[38;5;105m   ··{ESC}[0m\n"
    f"{ESC}[38;5;105m   ╱══╲{ESC}[0m\n"
    f"{ESC}[38;5;175m╰────────────────╯{ESC}[0m"
)
TRUECOLOR = (
    f"{ESC}[38;2;255;100;50mRED{ESC}[0m plain "
    f"{ESC}[1m{ESC}[38;2;50;200;255mBLUE{ESC}[0m tail of text here"
)

# name: (text, style, width, height)  — text None means the C0 probe
CASES = {
    "1": ("hi\nthere\nand more lines\nthan wanted\nextra", "ascii", 10, 3),
    "2": (None, "ascii", 8, 1),
    "3": (MUSHROOM, "unicode", 24, 4),
    "4": (TRUECOLOR, "truecolor", 30, 3),
    "5": ("桔樱unicode混合", "unicode", 10, 2),
    "6": (MUSHROOM, "ansi256", 24, 4),
    "7": (TRUECOLOR, "truecolor", 30, 3),
    "8": (MUSHROOM, "ansi16", 24, 4),
}

for name, (text, style, w, h) in CASES.items():
    src = C0_IN if text is None else text
    if text is not None:
        (V / f"input_{name}.txt").write_text(src, encoding="utf-8")
    out = mod.normalize_art(src, style, w, h)
    (V / f"expected_{name}.txt").write_text(out, encoding="utf-8")
    (V / f"meta_{name}.txt").write_text(f"{style} {w} {h}", encoding="utf-8")

# what does the oracle ACTUALLY do with 38;5 under each style?
probe = f"{ESC}[38;5;175mX{ESC}[0m"
report = []
for style in ("unicode", "ansi16", "ansi256", "truecolor", "ascii"):
    r = mod.normalize_art(probe, style, 4, 1)
    report.append(f"{style}: keeps_38_5={'38;5' in r} len={len(r)}")
(V / "wound-report.txt").write_text("\n".join(report) + "\n", encoding="utf-8")

print("oracle done")
print("\n".join(report))
