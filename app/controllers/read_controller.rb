class ReadController < ApplicationController

  get "/read" do
    @reads = Read.all
    @years = Read.years
    haml :read
  end
end
