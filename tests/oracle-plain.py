#!/usr/bin/env python3
"""Oracle: what does the TRUE normalize_art do with plain SGR codes,
per style? This is the case the current vectors never exercise."""
import sys, importlib.machinery, importlib.util
from pathlib import Path

sys.path.insert(0, str(Path.home() / "bin"))
# ~/bin/imp is now the C body. The python original lives in the faeOS kit,
# and it is the ONLY authority for what `reap` must reproduce.
PY_IMP = Path.home() / "faeOS" / "bin" / "imp"
if not PY_IMP.is_file():
    raise SystemExit(f"python imp not found at {PY_IMP}")
loader = importlib.machinery.SourceFileLoader(
    "fae_imp_oracle2", str(PY_IMP))
spec = importlib.util.spec_from_loader(loader.name, loader)
mod = importlib.util.module_from_spec(spec)
sys.modules[loader.name] = mod
spec.loader.exec_module(mod)

V = Path.home() / "imp" / "tests" / "vectors"
V.mkdir(parents=True, exist_ok=True)
ESC = "\x1b"

# a line using only codes every style should tolerate
PLAIN = f"{ESC}[1;31mRED{ESC}[0m tail of the line here"
# and one with 38;5 for contrast
C256  = f"{ESC}[38;5;175mX{ESC}[0m"

cases = {
    "9":  (PLAIN, "ansi16", 30, 3),
    "10": (PLAIN, "unicode", 30, 3),
    "11": (PLAIN, "ansi256", 30, 3),
    "12": (PLAIN, "truecolor", 30, 3),
}
for name, (text, style, w, h) in cases.items():
    (V / f"input_{name}.txt").write_text(text, encoding="utf-8")
    (V / f"expected_{name}.txt").write_text(
        mod.normalize_art(text, style, w, h), encoding="utf-8")
    (V / f"meta_{name}.txt").write_text(f"{style} {w} {h}", encoding="utf-8")

# what does the oracle KEEP for 1;31 under ansi16?
out = mod.normalize_art(f"{ESC}[1;31mZ{ESC}[0m", "ansi16", 8, 1)
print("ansi16 1;31  keeps:", "1;31" in out, "| out:", repr(out))
out2 = mod.normalize_art(f"{ESC}[1;31mZ{ESC}[0m", "unicode", 8, 1)
print("unicode 1;31 keeps:", "1;31" in out2, "| out:", repr(out2))
print("vectors 9-12 written")
