
var light = document.getElementById("lightmode")
var dark = document.getElementById("darkmode")

var currentURLForLight = window.location.href.replace(/$|\?mode=light/, "?mode=light")
var currentURLForDark = window.location.href.replace(/$|\?mode=light/, "")

if (light) {
  light.setAttribute("href", currentURLForLight)
} else {
  dark.setAttribute("href", currentURLForDark)
}
