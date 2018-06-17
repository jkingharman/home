class GitCommitFormatter
  def initialize(commits)
    @commits = commits
  end

  def structure_commits
    hash = commits.map do |commit|
      commit_month = Date.parse(commit.attribute("data-date").value).month
      [commit_month, []]
    end.to_h

    commits.map do |commit|
      commit_month = Date.parse(commit.attribute("data-date").value).month
      hash["commit_month"] << Date.parse(commit.attribute("data-count").value)
    end
    hash
  end

  private

  attr_reader :commits
end
