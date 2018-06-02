class ScrapsController < ApplicationController

  get "/scraps" do
    @title = "Scraps"
    @scraps = Scrap.order(:created_at)

    haml :scraps
  end
end
