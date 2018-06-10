class ReadController < ApplicationController

  get "/read" do
    @reads = Read.all
    haml :read
  end
end
