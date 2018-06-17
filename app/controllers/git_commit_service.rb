require 'nokogiri'
require 'restclient'
require 'date'
require 'pry'

class GitCommitService
  CONTRIBUTIONS_URL = "https://github.com/users/jkingharman/contributions"

  def initialize(parser: Nokogiri, days: 182)
    page = get_page(parser)
    @date = date_days_ago(days)
    @commits = daily_commits_from(page, date)
  end

  def commits_each_day
    commits.map {|commit| commit.attribute("data-count").value }
  end

  private

  attr_reader :commits, :date

  def get_page(parser)
    parser::HTML(RestClient.get(CONTRIBUTIONS_URL))
  end

  def date_days_ago(days)
    (Date.today - days).to_s
  end

  def daily_commits_from(page, date)
    commits = page.css("body svg g g")
    date_pos = commits.css("rect").find_index {|commit| commit.attribute("data-date").value == date }
    commits.css("rect")[date_pos..-1]
  end
end
