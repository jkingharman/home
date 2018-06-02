class Scrap < ActiveRecord::Base
  scope :unique_years, -> { pluck(:created_at).map(&:year).uniq }
end
