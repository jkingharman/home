var selectedTags = []
var tagElements = document.getElementsByClassName("tag")

var hideAnyTagNotSelectedFn = function(e) {
  var entryElements = document.getElementsByClassName("entry")

  for(var i=0;i<entryElements.length;i++){
    var entryElement = entryElements[i]
    var entryElementTags = entryElement.getAttribute("data-tags").split(",").map(function(e) { return e.trim() } )

    if (selectedTags.length == 0 || selectedTags.some(function(e) { return entryElementTags.includes(e) })) {
      entryElement.classList.remove("hide")
    } else {
      entryElement.classList.add("hide")
    }
  }
}

var addOrRemoveSelectedTagFn = function(e) {
  var tag = e.target.textContent
  e.target.classList.toggle("active")

  if (selectedTags.includes(tag)) {
    selectedTags = selectedTags.filter(function(e) { return e !== tag })
  } else {
    selectedTags.push(tag)
  }

  hideAnyTagNotSelectedFn()
};

for(var i=0;i<tagElements.length;i++){
  tagElements[i].addEventListener("click", addOrRemoveSelectedTagFn);
}
