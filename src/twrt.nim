const doc = """
The Weird Radio Transmitter

| This software is open source!
| https://github.com/exitcas/twrt.git

Usage:
    twrt --help
    twrt --version
    twrt post <caption>...
    twrt build
Try:
    twrt post "Lorem Impsum"
    twrt build
"""

import
    os,
    docopt,
    nimpy,
    strutils,
    times
import modules/[
    core,
    neocities,
    mastodon
]
let generate_card = pyImport("generate_card")
    


var args = docopt(doc, help=true, version="The Weird Radio Transmitter\nv1.0.1\n2023-02-09")

if args["post"]:
    var caption = args["<caption>"][0]
    echo "Generating ID..."
    var id: int = 0
    discard existsOrCreateDir("export")
    discard existsOrCreateDir("export/imgs")
    for x in walkDir("export/imgs"): id += 1
    id += 1
    var date = now().utc.format("YYYY'-'MM'-'dd'T'HH':'MM':'ss'.'fff'Z'")
    echo "Generating image..."
    discard generate_card.generate_card("export/imgs/" & intToStr(id) & ".jpg", caption)
    echo "Generating new 'transmissions.json' file..."
    newTransmission(id, caption, date)
    #echo "Updating the RSS feed..."
    echo "Uploading to site..."
    uploadTransmission(id)
    echo "Posting to Mastodon..."
    postStatus(caption)


if args["build"]:
    echo "Generating..."
    discard existsOrCreateDir("export")
    buildWebsite()
    echo "Uploading..."
    uploadWebsite()
