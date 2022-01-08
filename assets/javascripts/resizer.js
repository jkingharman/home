var sectionContainer = document.getElementById("section-container")
var contact = document.getElementById("contact-section")
var post = document.getElementById("posts-section")
var about = document.getElementById("about-section")

if (window.innerHeight >= (about.offsetHeight + sectionContainer.offsetHeight)) {
  var diff = window.innerHeight - (about.offsetHeight + sectionContainer.offsetHeight)
  sectionContainer.style.height = (sectionContainer.offsetHeight + diff + 50)
}
