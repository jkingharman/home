require 'time'

module Helpers
  module Sort
    def asc_posted_at(objs)
      objs.sort { |x, y| Date.parse(x.date) <=> Date.parse(y.date) }.reverse
    end
  end
end
