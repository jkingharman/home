module Presenter
  class Fragment
    def initialize(fragment)
      @frag = fragment
    end

    def prepare
      insert_any_images
      @frag
    end

    private

    def insert_any_images
      p "PRESENTEr"
      frag_img_folder = "./assets/images/" + "#{@frag.slug}"
      p frag_img_folder
      return unless Dir.exists?(frag_img_folder) && @frag.content.match?("<div class=\"gallery\">")

      imgs = Dir.entries("./assets/images/" + "#{@frag.slug}").select {|file| file.match?(/.[jpg|png]$/) && file.match?("-compress-blur") }
      p imgs
      elems = imgs.sort.map {|img| "<p> <img src='/assets/#{@frag.slug}/#{img}' style='width: %100; height: %100'> </img> </p>" }

      p elems

      elems.each {|elem| @frag.content.gsub!("<div class=\"gallery\">", "<div class=\"gallery\"> #{elem}") }
    end
  end
end
