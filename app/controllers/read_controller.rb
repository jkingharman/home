class ReadController < ApplicationController

  get "/read" do
    git_service = CommitFinder.new

    @reads = Read.all
    @years = Read.years
    @date = git_service.first_commit_date
    @series = git_service.daily_commit_totals
    haml :read
  end
end
