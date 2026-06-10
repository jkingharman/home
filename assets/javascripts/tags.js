// Tag filter for the posts page. Selected tags are mirrored to the URL
// (?tags=a,b) so a filtered view survives back/forward and can be linked.
var tagElements = document.getElementsByClassName("tag")
var selectedTags = []

var parseTagsFromURL = function() {
  var query = window.location.search.split("tags=")[1]
  return query ? query.split(",").filter(function(tag) { return tag !== "" }) : []
}

var render = function() {
  var entries = document.getElementsByClassName("entry")

  for (var i = 0; i < entries.length; i++) {
    var entryTags = entries[i].getAttribute("data-tags").split(",").map(function(tag) { return tag.trim() })
    var visible = selectedTags.length === 0 ||
      selectedTags.some(function(tag) { return entryTags.includes(tag) })
    entries[i].classList.toggle("hide", !visible)
  }

  for (var i = 0; i < tagElements.length; i++) {
    tagElements[i].classList.toggle("active", selectedTags.includes(tagElements[i].textContent))
  }
}

var toggleTag = function(e) {
  var tag = e.target.textContent

  if (selectedTags.includes(tag)) {
    selectedTags = selectedTags.filter(function(t) { return t !== tag })
  } else {
    selectedTags.push(tag)
  }

  render()
  window.history.pushState({}, "", selectedTags.length ? "?tags=" + selectedTags.join(",") : window.location.pathname)
}

for (var i = 0; i < tagElements.length; i++) {
  tagElements[i].addEventListener("click", toggleTag)
}

window.onload = window.onpopstate = function() {
  selectedTags = parseTagsFromURL()
  render()
}
