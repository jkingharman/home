module Presenter
  class Scrap
    IMAGES_ROOT = File.expand_path("../../assets/images", __dir__)

    def initialize(scrap)
      @scrap = scrap
    end

    def prepare
      insert_any_images
      @scrap
    end

    private

    def insert_any_images
      scrap_img_folder = File.join(IMAGES_ROOT, @scrap.slug)
      return unless Dir.exist?(scrap_img_folder) && @scrap.content.match?("<div class=\"gallery\">")

      imgs = Dir.entries(scrap_img_folder).select {|file| file.end_with?("-compress.jpg") }
      elems = imgs.sort.map {|img| "<p> <img src='/assets/#{@scrap.slug}/#{img}' loading='lazy'> </p>" }
      elems.each {|elem| @scrap.content.gsub!("<div class=\"gallery\">", "<div class=\"gallery\"> #{elem}") }
    end
  end
end
