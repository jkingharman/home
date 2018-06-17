require_relative "chart_service"

class ReadController < ApplicationController

  get "/read" do
    cs = ChartService.new
    @series = cs.series
    @reads = Read.all
    @years = Read.years
    haml :read
  end
end
