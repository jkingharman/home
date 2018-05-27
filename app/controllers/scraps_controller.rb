class ScrapsController < ApplicationController

  get "/scraps" do
    haml :scraps
  end
end
