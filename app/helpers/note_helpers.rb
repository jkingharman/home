require 'time' # remove if needed

module Helpers
  module Note
    def asc_order(notes)
      notes.sort { |x, y| Date.parse(x.date) <=> Date.parse(y.date) }.reverse
    end
  end
end
