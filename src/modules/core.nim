import os, json

proc config* (): JsonNode = return parseFile("config.json")

proc newTransmission* (
    id: int,
    caption: string,
    date: string,
) =
    var data: JsonNode
    if fileExists("export/transmissions.json"): data = parseFile("export/transmissions.json")
    else: data = newJArray()
    var newEntry = newJObject()
    newEntry.add("id", newJInt(id))
    newEntry.add("caption", newJString(caption))
    newEntry.add("date", newJString(date))
    newEntry.add("note", newJString(""))
    data.add(newEntry)
    writeFile("export/transmissions.json", data.pretty())