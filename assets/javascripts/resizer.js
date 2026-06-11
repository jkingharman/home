var sectionContainer = document.getElementById("section-container")
var contact = document.getElementById("contact-section")
var post = document.getElementById("posts-section")
var about = document.getElementById("about-section")

if (sectionContainer) {
  if (window.innerHeight >= (about.offsetHeight + sectionContainer.offsetHeight)) {
    var diff = window.innerHeight - (about.offsetHeight + sectionContainer.offsetHeight)
    // Units are required in standards mode; quirks mode used to accept a bare number.
    sectionContainer.style.height = (sectionContainer.offsetHeight + diff + 50) + "px"
  }
}
