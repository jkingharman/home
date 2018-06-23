
class SkateController < ApplicationController

  get "/skate" do
    Skate.build_structs
  end
end
