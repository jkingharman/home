require "date"
class CommitFormatter
  def initialize(commits)
    @commits = commits
  end

  def daily_commit_totals
    commits.map {|commit| commit.attribute("data-count").value.to_i }
  end

  def first_commit_date
    first_commit = commits.first
    commit_date = Date.parse(first_commit.attribute("data-date").value)

    [commit_date.year, (commit_date.month - 1), commit_date.day] # JS Date.UTC expects months from 0 to 11
  end

  private

  attr_reader :commits
end
