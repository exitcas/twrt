const page = 12;    // Max of images peer page
var already = 0;    // Counter of photos already on the gallery
var data = [];      // Loaded from transmissions.json
var bottom = false; // Reached the bottom?

// Get initial data
async function getNewData () {
  document.getElementById("loading").style = "display: block;";
  const resp = await fetch("transmissions.json");
  const json = await resp.json();
  return json;
}
// Store data into the 'data' function when gotten
getNewData().then(contents => {
  data = contents;
  data.reverse();
  document.getElementById("more").style = "display: block;";
  renderMore();
});
function scapeTags (text) {
  text = text.toString();
  text = text.split("<");
  text = text.join("&lt;");
  text = text.split(">");
  text = text.join("&gt;");
  return text;
}
function bottomReached () {
  document.getElementById("more").style = "display: none;";
  bottom = true;
}
function renderMore () {
  if (data.length === 0) {
    document.getElementById("gallery").innerHTML = "No images :/";
    return;
  }
  // Try getting the max of images
  for (var i = 0; i < page; i++) {
    // Check if we haven't reached the last item
    console.log(data[already + 1]);
    // Get information and add image if it is
    var info = data[already];
    var note = info["note"];
    if (note !== "") { note = "<br />Note: <i>" + note + "</i>"; }
    // Parse date
    var date = new Date(info["date"].toString()).toUTCString();
    // Add to the gallery
    document.getElementById("gallery").innerHTML += `
      <li>
        <a href="imgs/${info["id"].toString()}.jpg" target="_blank"><img alt="${scapeTags(info["caption"])}" title="Click to open!" src="imgs/${info["id"].toString()}.jpg" /></a>
        <br />
        <span>
          Caption: <i>${scapeTags(info["caption"])}</i>
          <br />
          Date: ${date}
        ${note}
        </span>
      </li>
    `;
    if (typeof data[already + 1] === "undefined") {
      bottomReached();
      break;
    }
    already++; // Count!
  }
  document.getElementById("loading").innerHTML = "";
}
