import core, strutils, httpclient, json, rt

var token = config()["neocities_token"].getStr()

const pages = [
    ["index.html", "Introduction"],
    ["transmissions.html", "Transmissions"],
    ["about_me.html", "About me"],
    ["not_found.html", "Page not found"]
]

proc generateHeaders (): HttpHeaders =
    return newHttpHeaders({ "Authorization": "Bearer " & token })

#proc nukeWebsite* (status: string): bool =
#    var client = newHttpClient()
#    client.headers = generateHeaders()
#    var files = parseJson(client.getContent("https://neocities.org/api/list"))["files"]
#    var filenames: tuple[]
#    for x in files:
#        if x["path"].getStr() != "imgs": filenames.add(x["path"].getStr())
#    var data = newMultipartData()
#    #data["output"] = ("soap12")
#    data["filenames"] = filenames
#    discard client.postContent("https://neocities.org/api/delete", multipart=data)


proc buildWebsite* () =
    for x in pages:
        echo "==> Generating '" & x[0] & "'..."
        writeFile("export/" & x[0],
            rt(x[0], [
                ["header", rt("_header.html", ["title", x[1]])],
                ["footer", rt("_footer.html")],
            ])
        )
    echo "==> Copying 'style.css' into the 'export' folder..."
    writeFile("export/style.css", rt("style.css", []))
    echo "==> Copying 'favicon.ico' into the 'export' folder..."
    writeFile("export/favicon.ico", rt("favicon.ico", []))
    echo "==> Copying 'icon.jpg' into the 'export' folder..."
    writeFile("export/icon.jpg", rt("icon.jpg", []))


proc uploadWebsite* () =
    var client = newHttpClient()
    client.headers = generateHeaders()
    var data = newMultipartData()
    data.addFiles({
        "index.html": "export/index.html",
        "transmissions.html": "export/transmissions.html",
        "about_me.html": "export/about_me.html",
        "not_found.html": "export/not_found.html",
        "style.css": "export/style.css",
        "favicon.ico": "export/favicon.ico",
        "icon.jpg": "export/icon.jpg"
    })
    discard client.postContent("https://neocities.org/api/upload", multipart=data)

proc uploadTransmission* (idSrc: int) =
    var id = idSrc.intToStr()
    var client = newHttpClient()
    client.headers = generateHeaders()
    var data = newMultipartData()
    data.addFiles({
        "imgs/" & id & ".jpg": "export/imgs/" & id & ".jpg",
        "transmissions.json": "export/transmissions.json"
    })
    discard client.postContent("https://neocities.org/api/upload", multipart=data)