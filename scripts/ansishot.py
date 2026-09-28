#!/usr/bin/env python3
"""ansishot — render an ANSI art file to a PNG, for README and story stills.

Impress draws a picture and saves it as ANSI. That is the right format for a
terminal and the wrong one for a README, so this rasterises the real output
rather than staging a screenshot of something else.

Supports the SGR subset Imp actually emits: 38;2;r;g;b truecolor, 38;5;n
256-colour, 48;2;r;g;b background, 1 bold, 0 reset. Anything else is ignored
rather than mis-rendered.

    ansishot.py IN.ans OUT.png [--cell 14] [--pad 24] [--title Imp]
"""
from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont

HOUSE_FONT = "/usr/share/fonts/TTF/DejaVuSansMono.ttf"
# Imp renders images as braille (U+2800-U+28FF), and DejaVu Sans Mono has no
# coverage there -- fontconfig silently substitutes FreeMono, which is why a
# braille render through the house font comes out as tofu. House mono is the
# rule for *type*; a braille grid is artwork that happens to be text, so it
# gets the font that has the glyphs. Sigils and prose stay on the house face.
BRAILLE_FONT = "/usr/share/fonts/gnu-free/FreeMono.otf"
NIGHT = (0x1A, 0x12, 0x18)
DEFAULT_FG = (0xF0, 0xE4, 0xEE)
SGR = re.compile(r"\x1b\[([0-9;]*)m")

# xterm-256: 0-15 system, 16-231 the 6x6x6 cube, 232-255 greyscale.
def xterm256(n: int) -> tuple[int, int, int]:
    if n < 16:
        base = [(0, 0, 0), (205, 0, 0), (0, 205, 0), (205, 205, 0),
                (0, 0, 238), (205, 0, 205), (0, 205, 205), (229, 229, 229),
                (127, 127, 127), (255, 0, 0), (0, 255, 0), (255, 255, 0),
                (92, 92, 255), (255, 0, 255), (0, 255, 255), (255, 255, 255)]
        return base[n]
    if n < 232:
        n -= 16
        steps = (0, 95, 135, 175, 215, 255)
        return (steps[n // 36], steps[(n // 6) % 6], steps[n % 6])
    v = 8 + (n - 232) * 10
    return (v, v, v)


class Cell:
    __slots__ = ("ch", "fg", "bg", "bold")

    def __init__(self) -> None:
        self.ch, self.fg, self.bg, self.bold = " ", DEFAULT_FG, None, False


def parse(text: str) -> list[list[Cell]]:
    """ANSI text -> a grid of cells. State carries across lines, as a terminal does."""
    grid: list[list[Cell]] = []
    row: list[Cell] = []
    fg, bg, bold = DEFAULT_FG, None, False
    i = 0
    while i < len(text):
        m = SGR.match(text, i)
        if m:
            body = m.group(1)
            parts = [int(p) for p in body.split(";") if p != ""] or [0]
            j = 0
            while j < len(parts):
                p = parts[j]
                if p == 0:
                    fg, bg, bold = DEFAULT_FG, None, False
                elif p == 1:
                    bold = True
                elif p == 38 and j + 1 < len(parts):
                    if parts[j + 1] == 2 and j + 4 < len(parts):
                        fg = tuple(parts[j + 2:j + 5]); j += 4
                    elif parts[j + 1] == 5 and j + 2 < len(parts):
                        fg = xterm256(parts[j + 2]); j += 2
                elif p == 48 and j + 1 < len(parts):
                    if parts[j + 1] == 2 and j + 4 < len(parts):
                        bg = tuple(parts[j + 2:j + 5]); j += 4
                    elif parts[j + 1] == 5 and j + 2 < len(parts):
                        bg = xterm256(parts[j + 2]); j += 2
                j += 1
            i = m.end()
            continue
        ch = text[i]
        i += 1
        if ch == "\n":
            grid.append(row); row = []
            continue
        if ch == "\r":
            continue
        c = Cell(); c.ch, c.fg, c.bg, c.bold = ch, fg, bg, bold
        row.append(c)
    if row:
        grid.append(row)
    return grid


def pick_font(text: str, size: int) -> ImageFont.FreeTypeFont:
    """House mono unless the art needs braille, which it does not have."""
    braille = any(0x2800 <= ord(c) <= 0x28FF for c in text)
    path = BRAILLE_FONT if braille else HOUSE_FONT
    if not Path(path).is_file():
        path = HOUSE_FONT
    return ImageFont.truetype(path, size)


def render(grid: list[list[Cell]], cell: int, pad: int, out: Path,
           title: str = "", src: str = "") -> tuple[int, int]:
    cols = max((len(r) for r in grid), default=1) or 1
    rows = len(grid) or 1
    head = int(cell * 1.8) + (int(cell * 2.4) if title else 0)
    W = cols * cell + pad * 2
    H = rows * cell + pad * 2 + head
    img = Image.new("RGB", (W, H), NIGHT)
    d = ImageDraw.Draw(img)
    font = pick_font(src, int(cell * 0.92))
    if title:
        tf = ImageFont.truetype(HOUSE_FONT, int(cell * 1.5))
        d.text((pad, pad + int(cell * 0.2)), title, font=tf, fill=DEFAULT_FG)
    y0 = pad + head
    for r, row in enumerate(grid):
        for c, cellv in enumerate(row):
            x = pad + c * cell
            y = y0 + r * cell
            if cellv.bg:
                d.rectangle([x, y, x + cell, y + cell], fill=tuple(cellv.bg))
            if cellv.ch != " ":
                d.text((x, y), cellv.ch, font=font, fill=tuple(cellv.fg or DEFAULT_FG))
    img.save(out)
    return W, H


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("src")
    ap.add_argument("dst")
    ap.add_argument("--cell", type=int, default=14)
    ap.add_argument("--pad", type=int, default=24)
    ap.add_argument("--title", default="")
    a = ap.parse_args()
    src = Path(a.src)
    if not src.is_file():
        print(f"ansishot: no such file: {src}", file=sys.stderr)
        return 1
    raw = src.read_text(errors="replace")
    W, H = render(parse(raw), a.cell, a.pad, Path(a.dst), a.title, raw)
    print(f"ansishot: {src} -> {a.dst} ({W}x{H})")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
