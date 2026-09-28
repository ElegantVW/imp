#!/usr/bin/env python3
"""Can any local model follow the grid contract? Ask each candidate the
exact prompt the imp will use and measure conformance: fence-free, line
count, and visible width per line."""
import json, sys, time, urllib.request, re
from pathlib import Path

WIDTH, HEIGHT = 30, 10

SYSTEM = f"""You are a terminal art generator. You output ONLY the requested art.
RULES:
- Output pure terminal art using box-drawing characters and ANSI color codes.
- Output ONLY the art. NO markdown fences, NO explanations, NO prose, NO code.
- Every line must be exactly {WIDTH} visible columns wide. ANSI codes and
  box-drawing characters do NOT add to the visible width.
- Output exactly {HEIGHT} lines.
- End every line with the reset sequence ESC[0m. No trailing characters after it.
- Be economical with color: use whole-line or per-segment colors, not one escape
  per character. Keep the whole piece under ~1400 characters.
COLORS: use ANSI 256-color foreground codes like ESC[38;5;Nm (N = 0-255), bold ESC[1m, reset ESC[0m.
SHAPE: you may use Unicode box-drawing and stars.
- Scene: a dragon coiled in a well"""


def visible(line: str) -> int:
    return len(re.sub(r"\x1b\[[0-9;]*[a-zA-Z]", "", line))


def ask(port, model, prompt, timeout=280, max_tokens=700, think=True):
    body = {"model": model, "messages": [
        {"role": "system", "content": SYSTEM},
        {"role": "user", "content": f"Create terminal art for: {prompt}"}],
        "temperature": 0.85, "max_tokens": max_tokens, "stream": False}
    if not think:
        body["chat_template_kwargs"] = {"enable_thinking": False}
    req = urllib.request.Request(
        f"http://127.0.0.1:{port}/v1/chat/completions",
        data=json.dumps(body).encode(),
        headers={"Content-Type": "application/json"}, method="POST")
    t0 = time.time()
    raw = json.loads(urllib.request.urlopen(req, timeout=timeout).read())
    art = raw["choices"][0]["message"]["content"]
    return art, time.time() - t0


def report(tag, art, dt):
    lines = art.split("\n")
    fenced = "```" in art
    widths = [visible(l) for l in lines]
    ok_w = sum(1 for w in widths if w == WIDTH)
    print(f"\n=== {tag}  ({dt:.1f}s, {len(art)} chars, {len(lines)} lines) ===")
    print(f"  fences: {fenced}   lines=={HEIGHT}: {len(lines)==HEIGHT}"
          f"   lines at width {WIDTH}: {ok_w}/{len(lines)}")
    print(f"  widths: {widths[:12]}")
    return art


if __name__ == "__main__":
    port = int(sys.argv[1]) if len(sys.argv) > 1 else 8082
    model = sys.argv[2] if len(sys.argv) > 2 else "imp"
    think = "--think" in sys.argv
    art, dt = ask(port, model, "a dragon coiled in a well", think=think)
    report(f"port {port} / {model} think={think}", art, dt)
    print("\n--- REPR of first 4 lines ---")
    for l in art.split("\n")[:4]:
        print(repr(l[:160]))
    print("\n--- counts ---")
    print("real ESC bytes :", art.count("\x1b"))
    print("literal ESC[   :", art.count("ESC["))
    print("<think> blocks :", art.count("<think>"))
    print("\n--- BODY ---")
    print(art[-1200:])
