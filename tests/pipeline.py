#!/usr/bin/env python3
"""End-to-end: can the model be made to obey the contract by correction
alone? Strips reasoning, un-escapes literal ESC text, then hands the
result to the sealed normalize_art and measures what actually lands."""
import importlib.machinery, importlib.util, json, re, sys, time, urllib.request
from pathlib import Path

sys.path.insert(0, str(Path.home() / "bin"))
loader = importlib.machinery.SourceFileLoader(
    "fae_imp_oracle3", str(Path.home() / "faeOS" / "bin" / "imp"))
spec = importlib.util.spec_from_loader(loader.name, loader)
imp = importlib.util.module_from_spec(spec)
sys.modules[loader.name] = imp
spec.loader.exec_module(imp)

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


def ask(prompt, port=8082, model="imp", timeout=280, max_tokens=700,
        think=True, temp=0.85):
    body = {"model": model, "messages": [
        {"role": "system", "content": SYSTEM},
        {"role": "user", "content": f"Create terminal art for: {prompt}"}],
        "temperature": temp, "max_tokens": max_tokens, "stream": False}
    if not think:
        body["chat_template_kwargs"] = {"enable_thinking": False}
    req = urllib.request.Request(
        f"http://127.0.0.1:{port}/v1/chat/completions",
        data=json.dumps(body).encode(),
        headers={"Content-Type": "application/json"}, method="POST")
    t0 = time.time()
    raw = json.loads(urllib.request.urlopen(req, timeout=timeout).read())
    return raw["choices"][0]["message"]["content"], time.time() - t0


def cure(text):
    """The corrections. All deterministic; none of them is a lie."""
    # 1. the model's private reasoning is not art
    text = re.sub(r"<think>.*?</think>", "", text, flags=re.S)
    text = re.sub(r"<think>.*", "", text, flags=re.S)
    # 2. it writes our notation instead of the byte
    text = text.replace("ESC[", "\x1b[")
    text = re.sub(r"\\033\[", "\x1b[", text)
    text = re.sub(r"\\x1b\[", "\x1b[", text)
    text = re.sub(r"\\e\[", "\x1b[", text)
    # 3. fences, prose, trailing space
    text = text.replace("```", "")
    text = "\n".join(l.rstrip() for l in text.split("\n"))
    return text.strip("\n")


def visible(s):
    return len(re.sub(r"\x1b\[[0-9;]*[a-zA-Z]", "", s))


if __name__ == "__main__":
    wish = "a dragon coiled in a well"
    think = "--think" in sys.argv
    temp = 0.85
    for a in sys.argv[1:]:
        if a.startswith("--temp="):
            temp = float(a.split("=", 1)[1])
        elif not a.startswith("--"):
            wish = a
    raw, dt = ask(wish, think=think, temp=temp)
    print(f"think={think} temp={temp}")
    print(f"raw      : {len(raw)} chars, {dt:.1f}s")

    healed = cure(raw)
    print(f"cured    : {len(healed)} chars, real ESC={healed.count(chr(27))}")

    grid = imp.normalize_art(healed, "unicode", WIDTH, HEIGHT)
    lines = grid.split("\n")
    print(f"grid     : {len(lines)} lines, widths={[visible(l) for l in lines]}")
    print(f"contract : lines=={HEIGHT} -> {len(lines)==HEIGHT}, "
          f"all widths {WIDTH} -> {all(visible(l)==WIDTH for l in lines)}")
    ink = sum(1 for l in lines
              if re.sub(r"\x1b\[[0-9;]*[a-zA-Z]", "", l).strip())
    print(f"inked    : {ink}/{HEIGHT} lines carry content")
    print("\n--- what the imp actually shows ---")
    print(grid)
