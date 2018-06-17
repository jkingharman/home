require_relative "git_commit_service"
require_relative "month_names"

class ReadController < ApplicationController

  get "/read" do
    chart_service = ChartService.new
    @month_names = ChartService.
    @series = ChartService.series
    @reads = Read.all
    @years = Read.years
    haml :read
  end
end
