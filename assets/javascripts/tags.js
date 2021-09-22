var selectedTags = []
var tagElements = document.getElementsByClassName("tag")

// Toggles the visibility of content elements depending on whether their tag is selected (show) or unselected (hide).
var hideAnyContentNotSelected = function(e) {
  var contentElements = document.getElementsByClassName("entry")
  for(var i=0;i<contentElements.length;i++){
    var contentElement = contentElements[i]
    var contentElementTags = contentElement.getAttribute("data-tags").split(",").map(function(e) { return e.trim() } )

    if (selectedTags.length == 0 || selectedTags.some(function(e) { return contentElementTags.includes(e) })) {
      contentElement.classList.remove("hide")
    } else {
      contentElement.classList.add("hide")
    }
  }
}

var makeAnySelectedTagElementsActive = function(e) {
  for(var i=0;i<tagElements.length;i++){
    var tagElement = tagElements[i]

    if (selectedTags.length == 0 || !selectedTags.includes(tagElement.textContent)) {
      tagElement.classList.remove("active")
    } else {
      tagElement.classList.add("active")
    }
  }
}

var updateURL = function(e) {
  window.history.pushState({}, "archive", "?tags=" + selectedTags.toString())
}

var deconstructURL = function(e) {
  if (window.location.href.split("tags=")[1] != undefined) {
    selectedTags = window.location.href.split("tags=")[1].split(",")
  } else {
    selectedTags = []
  }
}

// Click handler that updates the currently selected tags by pushing to or poping off an array
// On every tag update it will then invoke #hideAnyContentNotSelectedFn to also update content visibility.
var addOrRemoveSelectedTag = function(e) {
  var tag = e.target.textContent

  if (selectedTags.includes(tag)) {
    selectedTags = selectedTags.filter(function(e) { return e !== tag })
  } else {
    selectedTags.push(tag)
  }

  hideAnyContentNotSelected()
  makeAnySelectedTagElementsActive()
  updateURL()
};

for(var i=0;i<tagElements.length;i++){
  tagElements[i].addEventListener("click", addOrRemoveSelectedTag);
}

window.onload = function(e) {
  deconstructURL()
  hideAnyContentNotSelected()
  makeAnySelectedTagElementsActive()
}

window.onpopstate = function(e) {
  deconstructURL()
  hideAnyContentNotSelected()
  makeAnySelectedTagElementsActive()
}
