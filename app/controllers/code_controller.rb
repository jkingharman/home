require_relative "../services/commit_finder"
require "pry"

class CodeController < ApplicationController

  get "/code" do
    git_service = CommitFinder.new
    @date = git_service.first_commit_date
    @series = git_service.daily_commit_totals
    haml :code
  end
end
