class ScrapsController < ApplicationController

  get "/scraps" do
    @scraps = ["2018", "2017", "2016"]
    haml :scraps
  end
end
