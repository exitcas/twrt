from random import randint
from PIL import Image, ImageFont, ImageDraw
from PIL.ImageFilter import EDGE_ENHANCE_MORE
import textwrap

def generate_card(name, text):
    width   = 400
    height  = 300
    padding = 10


    img = Image.new(
        mode  = "RGBA",
        size  = (400, 300),
        color = (255, 255, 255)
    )
    draw = ImageDraw.Draw(img)
    noise = Image.effect_noise((img.width, img.height), randint(1, 128)).convert("RGBA")


    # Apply font
    font = ImageFont.truetype("./src/fonts/archivo.ttf", 25)
    wrap = textwrap.wrap(text, 25, break_long_words=True)
    text = "\n".join(wrap)



    # Get text size
    left, top, right, bottom = draw.textbbox((0, 0, 0), text, font=font)
    width, height = right - left, bottom - top
    #print(f"{str(width)}px {str(height)}px")


    # Get letter size
    letter_width = int(width / len(wrap[0]))
    letter_height = 25
    #print(f"{str(letter_width)}px {str(letter_height)}px")


    # Put text on a random spot of the screen
    try: x = randint(10, img.width - padding - width)
    except: x = 0
    try: y = randint(10, img.height - padding - height)
    except: y = 0
    draw.text(
        (x, y),
        text,
        (0, 0, 0),
        font = font
    )


    # Add "points"
    x = 3
    y = 3
    width = 0.5
    spacing = 20
    while y < img.height:
        while x < img.width:
            draw.ellipse((x, y, x + width, y + width), fill=(234, 234, 234))
            x += width + spacing
        x = 0
        y += width + spacing


    # Add green line
    #width = randint(3, 5)
    width = randint(3, 5)
    draw.line((img.width, 0, img.width, img.height), width=randint(3, 5), fill=(0, 255, 0))

    # Apply saturation filter and add gaussian noise
    img = img.filter(EDGE_ENHANCE_MORE)
    noise.putalpha(13) # 128
    img = Image.alpha_composite(img, noise)

    # Convert into JPEG image and save
    jpg = Image.new("RGB", img.size, (255, 255, 255))
    jpg.paste(img, mask=img.split()[3])
    jpg.save(name, "JPEG", quality="80", optimize=True)
