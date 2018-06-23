
class SkateController < ApplicationController

  get "/skate" do
    @skate = Skate.build_structs
    binding.pry
    haml :skate
  end
end
