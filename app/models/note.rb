class Note < ActiveRecord::Base
  scope :by_desc_year, -> { all.group_by(&:year) }
end
