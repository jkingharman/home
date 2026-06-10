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

      imgs = Dir.entries(scrap_img_folder).select {|file| file.match?(/.[jpg|png]$/) && file.match?("-compress-blur") }
      elems = imgs.sort.map {|img| "<p> <img src='/assets/#{@scrap.slug}/#{img}' style='width: %100; height: %100'> </img> </p>" }
      elems.each {|elem| @scrap.content.gsub!("<div class=\"gallery\">", "<div class=\"gallery\"> #{elem}") }
    end
  end
end
