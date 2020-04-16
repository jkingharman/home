
$(document).ready(function () {

  $(".gallery").each(function() {
    title = $(this).parent().find("h6").text().replace(" ", "_")
    folder = "assets/images/" + title

    $.ajax({
      url: folder,
      success: function(data) {
        title = data.pop()

        data.forEach(function (img) {
          htmlTitle = title.replace("_", " ")
          imagePath = "assets/" + title + "/" + img
          imgHTML = `<p> <img src=${imagePath}> </img> </p>`
          $("h6:contains(" + htmlTitle + ")").parent().find(".gallery").append(imgHTML)
        })
      }
    });
  });
});
