require 'nokogiri'
require 'restclient'
require 'date'
require_relative "git_commit_formatter"

class GitCommitService
  CONTRIBUTIONS_URL = "https://github.com/users/jkingharman/contributions"

  def initialize(parser: Nokogiri, months_ago: 6)
    page = get_page(parser)
    date = date_months_ago(months_ago)
    commits = daily_commits_from(page, date)

    @formatter = GitCommitFormatter.new(commits)
  end

  def daily_commit_totals
    formatter.daily_commit_totals
  end

  def first_commit_date
    formatter.first_commit_date
  end

  private

  attr_reader :formatter

  def get_page(parser)
    parser::HTML(RestClient.get(CONTRIBUTIONS_URL))
  end

  def date_months_ago(months)
    date = Date.today
    months.times { date = date.prev_month }
    date.to_s
  end

  def daily_commits_from(page, date)
    commits = page.css("body svg g g")
    date_pos = commits.css("rect").find_index {|commit| commit.attribute("data-date").value == date }
    commits.css("rect")[date_pos..-1]
  end
end
