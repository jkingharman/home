class ScrapsController < ApplicationController

  get "/scraps" do
    @title = "Scraps"
    @years_published = Scrap.unique_years.sort.reverse
    @scraps = Scrap.order(:created_at)

    haml :scraps
  end
end
