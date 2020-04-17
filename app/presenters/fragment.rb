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
      frag_img_folder = "./assets/images/" + "#{@frag.slug}"
      return unless Dir.exists?(frag_img_folder) && @frag.content.match?("<div class=\"gallery\">")

      imgs = Dir.entries("./assets/images/" + "#{@frag.slug}").select {|file| file.match?(/.[jpg|png]$/) }
      elems = imgs.map {|img| "<p> <img src='assets/#{@frag.slug}/#{img}'> </img> </p>" }
      elems.each {|elem| @frag.content.gsub!("<div class=\"gallery\">", "<div class=\"gallery\"> #{elem}") }
    end
  end
end
