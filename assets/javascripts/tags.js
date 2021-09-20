var selectedTags = []
var tagElements = document.getElementsByClassName("tag")

// Toggles the visibility of content elements depending on whether their tag is selected (show) or unselected (hide).
var hideAnyContentNotSelectedFn = function(e) {
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

// Click handler that updates the currently selected tags by pushing to or poping off an array
// On every tag update it will then invoke #hideAnyContentNotSelectedFn to also update content visibility.
var addOrRemoveSelectedTagFn = function(e) {
  var tag = e.target.textContent
  e.target.classList.toggle("active")

  if (selectedTags.includes(tag)) {
    selectedTags = selectedTags.filter(function(e) { return e !== tag })
  } else {
    selectedTags.push(tag)
  }

  hideAnyContentNotSelectedFn()
};

for(var i=0;i<tagElements.length;i++){
  tagElements[i].addEventListener("click", addOrRemoveSelectedTagFn);
}
