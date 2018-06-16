require_relative "git_service"
require 'pry'

# is there a way to dynamically create here?

class ChartService
  def initialize(git_service: GitService.new)
    @git_service = git_service
    @series = [
      {data: []},
      {data: []},
      {data: []},
      {data: []}
    ]
  end

  def get_series
    week_totals = git_service.week_totals
    create_series(week_totals)
  end

  attr_reader :series

  private

  attr_reader :git_service

  def create_series(totals)
    week_in_month = 0
    totals.each do |total|
      series[week_in_month][:data] << total
      week_in_month == 3 ? week_in_month = 0 : week_in_month += 1
    end
  end
end
