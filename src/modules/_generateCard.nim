import nimpy
let PIL = pyImport("PIL")
#from random import randint
#from PIL import Image, ImageFont, ImageDraw
#from PIL.ImageFilter import EDGE_ENHANCE_MORE
#import textwrap

proc generate_card* (text: string) =
    var width   = 400
    var height  = 300
    var padding = 10


    #img = Image.open("sample_in.jpg")
    var img = PIL.Image.new(
        mode  = "RGBA",
        size  = (400, 300),
        color = (255, 255, 255)
    )
    var draw = PIL.ImageDraw.Draw(img)
    var noise = PIL.Image.effect_noise((img.width, img.height), randint(1, 128)).convert("RGBA")


    #  
    font = ImageFont.truetype("archivo.ttf", 25)
    #text = "\n".join(textwrap.wrap("This post might be part of your imagination, or a test for the new filtering system. The Babies aren't real. They're surveilance devices made out by the Dads to know if the kids are using the to take the Kids out of the Forums.", 33, break_long_words=True))
    var wrap = textwrap.wrap(text, 33, break_long_words=True)
    var text = "\n".join(wrap)



    # Get text size
    var left, top, right, bottom = draw.textbbox((0, 0, 0), text, font=font)
    width, height = right - left, bottom - top
    print(f"{str(width)}px {str(height)}px")


    # Get letter size
    letter_width = int(width / len(wrap[0]))
    letter_height = 25
    print(f"{str(letter_width)}px {str(letter_height)}px")


    # Put text on a random spot of the screen
    x = randint(10, img.width - padding - width)
    #if x < 0: x = 0
    y = randint(10, img.height - padding - height)
    #if y < 0: y = 0
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

    # Apply saturation filter and save
    img = img.filter(EDGE_ENHANCE_MORE)
    noise.putalpha(13) # 128
    img = Image.alpha_composite(img, noise)
    img.save("text_spans.png")