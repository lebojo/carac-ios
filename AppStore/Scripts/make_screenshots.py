#!/usr/bin/env python3
"""Render the App Store screenshots, with caption and device frame, from the screenshot configs."""
import argparse
import json
import os
from PIL import Image, ImageDraw

from make_creatives import ROOT, WHITE, bold_font, framed_phone, gradient, shadowed

CONFIG_DIR = os.path.join(ROOT, "Screenshots", "config")
DEVICES = {"sixPointSevenInch": "iphone", "iPadSixthGen": "ipad"}


def framed_ipad(screenshot_path):
    screen = Image.open(screenshot_path).convert("RGBA")
    border, radius = 60, 150
    size = (screen.width + border * 2, screen.height + border * 2)
    frame = Image.new("RGBA", size, (0, 0, 0, 0))
    ImageDraw.Draw(frame).rounded_rectangle((0, 0, size[0] - 1, size[1] - 1), radius=radius, fill=(28, 28, 30, 255))
    ImageDraw.Draw(frame).rounded_rectangle((6, 6, size[0] - 7, size[1] - 7), radius=radius - 6, outline=(72, 72, 76, 255), width=4)
    mask = Image.new("L", screen.size, 0)
    ImageDraw.Draw(mask).rounded_rectangle((0, 0, screen.width - 1, screen.height - 1), radius=radius - border, fill=255)
    frame.paste(screen, (border, border), mask)
    return frame


def wrapped(draw, text, font, max_width):
    if draw.textlength(text, font=font) <= max_width:
        return [text]
    words = text.split()
    splits = [[" ".join(words[:i]), " ".join(words[i:])] for i in range(1, len(words))]
    return min(splits, key=lambda lines: max(draw.textlength(line, font=font) for line in lines))


def fits(draw, lines, font, max_width):
    return all(draw.textlength(line, font=font) <= max_width for line in lines)


def caption_font(draw, text, max_width, size):
    while size > 40:
        font = bold_font(size, "Heavy")
        if fits(draw, wrapped(draw, text, font, max_width), font, max_width):
            return font
        size -= 4
    return bold_font(size, "Heavy")


def caption_box(device, size):
    w, _ = size
    is_phone = device == "iphone"
    return int(w * (0.86 if is_phone else 0.80)), int(w * (0.098 if is_phone else 0.068))


def group_font(device, captions, size):
    draw = ImageDraw.Draw(Image.new("RGB", (1, 1)))
    max_width, font_size = caption_box(device, size)
    return min((caption_font(draw, caption, max_width, font_size) for caption in captions), key=lambda font: font.size)


def compose(device, image_path, caption, font, size, out_path):
    w, h = size
    img = gradient(size).convert("RGBA")
    draw = ImageDraw.Draw(img)
    is_phone = device == "iphone"
    max_width, _ = caption_box(device, size)
    line_height = int(font.size * 1.12)
    lines = wrapped(draw, caption, font, max_width)
    band_top = int(h * 0.065)
    y = band_top + (2 - len(lines)) * line_height // 2
    for line in lines:
        box = draw.textbbox((0, 0), line, font=font)
        draw.text(((w - (box[2] - box[0])) // 2 - box[0], y), line, font=font, fill=WHITE)
        y += line_height

    device_image = framed_phone(image_path) if is_phone else framed_ipad(image_path)
    scale = (w * (0.84 if is_phone else 0.82)) / device_image.width
    framed, pad = shadowed(device_image, scale)
    top = band_top + 2 * line_height + int(h * 0.045)
    img.alpha_composite(framed, ((w - framed.width) // 2, top - pad))

    img.convert("RGB").save(out_path, "PNG", optimize=True)
    print(out_path, size)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--out", default=os.path.join(ROOT, "Screenshots", "export"))
    parser.add_argument("--langs", nargs="+", default=["en", "fr"])
    args = parser.parse_args()
    for lang in args.langs:
        config = json.load(open(os.path.join(CONFIG_DIR, f"{lang}.json")))
        for group in config["groups"]:
            device = DEVICES[group["device"]]
            out_dir = os.path.join(args.out, lang, device)
            os.makedirs(out_dir, exist_ok=True)
            size = tuple(group["size"])
            font = group_font(device, [shot["caption"] for shot in group["screenshots"]], size)
            for index, shot in enumerate(group["screenshots"], start=1):
                image_path = os.path.normpath(os.path.join(CONFIG_DIR, shot["image"]))
                compose(device, image_path, shot["caption"], font, size, os.path.join(out_dir, f"{index:02d}.png"))


if __name__ == "__main__":
    main()
