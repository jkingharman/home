class Read < ActiveRecord::Base
  def self.years
    all.map { |r| r.created_at.year }.uniq
  end
end
