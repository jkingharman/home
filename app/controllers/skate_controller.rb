
class SkateController < ApplicationController

  get "/skate" do
    @skate = Skate.build_structs
    haml :skate
  end
end
