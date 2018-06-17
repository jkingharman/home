require_relative "git_commit_service"
require 'pry'

class ChartService
  def initialize(git_service: GitCommitService.new)
    @git_service = git_service
    @series = [ {data: git_service.commits_each_day } ]
  end

  attr_reader :series

  private

  attr_reader :git_service
end
