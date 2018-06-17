require_relative "git_commit_service"

class ChartService
  def initialize(git_service: GitCommitService.new
    @git_service = git_service
  end

  private

  attr_reader :git_service, :month_service
end
