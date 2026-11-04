#!/usr/bin/env python3
"""Generate the iOS 27 App Store creative assets (product page header + search results)."""
import argparse
import os
from PIL import Image, ImageDraw, ImageFilter, ImageFont

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
BEZEL_DIR = os.path.join(HERE, "bezel")
FONT = "/System/Library/Fonts/SFNSRounded.ttf"

GREEN_TOP = (52, 199, 89)
GREEN_BOTTOM = (22, 128, 61)
WHITE = (255, 255, 255)

COPY = {
    "en": {"title": "Lift. Log. Progress.", "subtitle": "Your strength training, planned and tracked"},
    "fr": {"title": "Soulevez. Notez. Progressez.", "subtitle": "Vos séances de musculation, planifiées et suivies"},
}

SIZES = {
    "header": (3840, 1646),
    "search": (3840, 2560),
    "universal": (5244, 2950),
}

SHOTS = ["02-exercise.png", "01-home.png", "04-progress.png"]


def framed_phone(screenshot_path):
    bezel = Image.open(os.path.join(BEZEL_DIR, "iphone_18_pro_silver.png")).convert("RGBA")
    mask = Image.open(os.path.join(BEZEL_DIR, "iphone_18_pro_mask.png")).convert("RGBA").getchannel("A")
    screen = Image.open(screenshot_path).convert("RGBA").resize((1206, 2622), Image.LANCZOS)
    canvas = Image.new("RGBA", bezel.size, (0, 0, 0, 0))
    canvas.paste(screen, (72, 69))
    canvas.putalpha(Image.composite(canvas.getchannel("A"), Image.new("L", bezel.size, 0), mask))
    canvas.alpha_composite(bezel)
    return canvas


def gradient(size):
    w, h = size
    top = Image.new("RGB", size, GREEN_TOP)
    bottom = Image.new("RGB", size, GREEN_BOTTOM)
    ramp = Image.linear_gradient("L").resize(size)
    return Image.composite(bottom, top, ramp)


def shadowed(phone, scale):
    phone = phone.resize((int(phone.width * scale), int(phone.height * scale)), Image.LANCZOS)
    pad = int(140 * scale)
    shadow = Image.new("RGBA", (phone.width + pad * 2, phone.height + pad * 2), (0, 0, 0, 0))
    alpha = phone.getchannel("A").point(lambda a: int(a * 0.35))
    shadow.paste(Image.new("RGBA", phone.size, (0, 40, 10, 255)), (pad, pad + int(40 * scale)), alpha)
    shadow = shadow.filter(ImageFilter.GaussianBlur(60 * scale))
    shadow.alpha_composite(phone, (pad, pad))
    return shadow, pad


def bold_font(size, weight="Bold"):
    font = ImageFont.truetype(FONT, size)
    try:
        font.set_variation_by_name(weight)
    except Exception:
        pass
    return font


def fitted(draw, text, max_width, size, weight):
    while size > 20:
        font = bold_font(size, weight)
        if draw.textlength(text, font=font) <= max_width:
            return font
        size -= 4
    return bold_font(size, weight)


def compose(kind, lang, shots_dir, out_path):
    size = SIZES[kind]
    w, h = size
    img = gradient(size).convert("RGBA")
    draw = ImageDraw.Draw(img)
    phones = [framed_phone(os.path.join(shots_dir, name)) for name in SHOTS]
    copy = COPY[lang]

    if kind == "header":
        safe_left = int(w * 0.16)
        text_right = int(w * 0.49)
        title = fitted(draw, copy["title"], text_right - safe_left, 190, "Heavy")
        subtitle = fitted(draw, copy["subtitle"], text_right - safe_left, 84, "Semibold")
        tb = draw.textbbox((0, 0), copy["title"], font=title)
        sb = draw.textbbox((0, 0), copy["subtitle"], font=subtitle)
        block = (tb[3] - tb[1]) + 60 + (sb[3] - sb[1])
        y = (h - block) // 2
        draw.text((safe_left, y - tb[1]), copy["title"], font=title, fill=WHITE)
        draw.text((safe_left, y + (tb[3] - tb[1]) + 60 - sb[1]), copy["subtitle"], font=subtitle, fill=(232, 250, 236))
        scale = (h * 1.02) / phones[0].height
        positions = [(0.615, 0.22), (0.715, 0.10), (0.815, 0.22)]
        order = [0, 2, 1]
        for index in order:
            phone, pad = shadowed(phones[index], scale * (0.92 if index == 1 else 0.84))
            cx, top = positions[index]
            img.alpha_composite(phone, (int(w * cx - phone.width / 2), int(h * top) - pad))
    else:
        title = fitted(draw, copy["title"], int(w * 0.80), int(h * 0.085), "Heavy")
        subtitle = fitted(draw, copy["subtitle"], int(w * 0.75), int(h * 0.036), "Semibold")
        tb = draw.textbbox((0, 0), copy["title"], font=title)
        sb = draw.textbbox((0, 0), copy["subtitle"], font=subtitle)
        y = int(h * 0.075)
        draw.text(((w - (tb[2] - tb[0])) // 2 - tb[0], y - tb[1]), copy["title"], font=title, fill=WHITE)
        y2 = y + (tb[3] - tb[1]) + int(h * 0.03)
        draw.text(((w - (sb[2] - sb[0])) // 2 - sb[0], y2 - sb[1]), copy["subtitle"], font=subtitle, fill=(232, 250, 236))
        phones_top = y2 + (sb[3] - sb[1]) + int(h * 0.07)
        scale = (h * 0.95) / phones[0].height
        spacing = w * 0.235
        offsets = {0: (-spacing, 0.06), 1: (0, 0.0), 2: (spacing, 0.06)}
        for index in [0, 2, 1]:
            phone, pad = shadowed(phones[index], scale * (1.0 if index == 1 else 0.92))
            dx, dy = offsets[index]
            img.alpha_composite(phone, (int(w / 2 + dx - phone.width / 2), phones_top + int(h * dy) - pad))

    img.convert("RGB").save(out_path, "PNG", optimize=True)
    print(out_path, size)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--shots", default=os.path.join(ROOT, "Screenshots", "raw", "iphone"))
    parser.add_argument("--out", default=os.path.join(ROOT, "Creatives"))
    parser.add_argument("--langs", nargs="+", default=["en", "fr"])
    args = parser.parse_args()
    for lang in args.langs:
        os.makedirs(os.path.join(args.out, lang), exist_ok=True)
        for kind in SIZES:
            compose(kind, lang, os.path.join(args.shots, lang, "light"), os.path.join(args.out, lang, f"{kind}.png"))


if __name__ == "__main__":
    main()
