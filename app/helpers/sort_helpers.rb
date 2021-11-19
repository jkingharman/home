require 'time'

module Helpers
  module Sort
    def asc_posted_at(objs)
      objs.sort { |x, y| Date.parse(x.date) <=> Date.parse(y.date) }.reverse
    end

    def for_index(notes)
      notes.select {|note| note.index }.sort_by {|note| note.index }.reverse
    end
  end
end
