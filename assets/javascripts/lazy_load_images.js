
window.addEventListener("load", function(){

  var intersectionObserver = new IntersectionObserver(function(entries) {
    for (var i = 0; i < entries.length; i++) {
      entry = entries[i]

      if (entry.isIntersecting) {
        entry.target.src = entry.target.src.replace("-blur", "")
      }
    }
  });

  var imgs = document.getElementsByTagName("img")

  for (var i = 0; i < imgs.length; i++) {
    intersectionObserver.observe(imgs[i])
  }
});
