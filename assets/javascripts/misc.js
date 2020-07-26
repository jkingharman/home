
var light = document.getElementById("lightmode")
var dark = document.getElementById("darkmode")

// In light mode, append query param 'mode=light' to every internal link so the mode is preserved over page loads
if (window.location.href.match(/mode=light/)) {
  var links = document.getElementsByTagName("a")

  for (var i = 0; i < links.length; i++) {
    linkURL = links[i].href
    internalLinkPattern = /(127.0.0.1:9393|jaskh.net)/

    if (linkURL.match(internalLinkPattern)) {
      links[i].setAttribute("href", links[i].href.replace(/$|\?mode=light/, "?mode=light"))
    }
  }
}

var currentURLForLight = window.location.href.replace(/($|\?mode=light)/, "?mode=light")
var currentURLForDark = window.location.href.replace(/($|\?mode=light)/, "")

if (light) {
  light.setAttribute("href", currentURLForLight)
} else {
  dark.setAttribute("href", currentURLForDark)
}
