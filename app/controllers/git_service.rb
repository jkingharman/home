require 'nokogiri'
require 'restclient'
require 'pry'

class GitService
  CONTRIBUTIONS_URL = "https://github.com/users/jkingharman/contributions"

  def initialize(html_parser: Nokogiri)
    @parser = html_parser
  end

  def week_totals
    page = get_page
    get_week_totals(page)
  end

  private

  attr_reader :parser

  def get_page
    parser::HTML(RestClient.get(CONTRIBUTIONS_URL))
  end

  def get_week_totals(page)
    weeks = page.css("body svg g g")

    weeks.map do |week|
      days = week.css("rect")
      days.map { |day| day.attribute("data-count").value.to_i }.sum
    end
  end
end
