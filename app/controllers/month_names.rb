require "date"

class MonthNames
  MONTHNAMES = (1..12).to_a.zip(Date::MONTHNAMES.compact).to_h

  def initialize(months_ago: 6)
    @months_ago = months_ago
  end

  def call
    month_names = []
    date = Date.today

    months_ago.times do
      date = date.prev_month
      month_names << MONTHNAMES[date.month]
    end
    month_names.reverse
  end

  private

  attr_reader :months_ago
end
