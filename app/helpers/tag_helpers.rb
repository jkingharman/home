module Helpers
  module Tag
    def formatted_tags(tags_arr)
      tags_arr.map {|tag| tag == tags_arr.last ? tag : tag + " · "}.join
    end
  end
end
