import core, httpclient, json

proc postStatus* (status: string) =
    var client = newHttpClient()

    client.headers = newHttpHeaders({
        "Authorization": "Bearer " & config()["mastodon_token"].getStr(),
        "Content-Type": "application/json"
    })

    let body = %*{ "status": status }

    var bodyStr: string
    bodyStr.toUgly(body)
    
    discard client.postContent("https://" & config()["mastodon_instance"].getStr() & "/api/v1/statuses", body=bodyStr)