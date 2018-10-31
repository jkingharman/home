
require_relative "../helpers/note_helpers" # extract
require_relative "../helpers/markdown_helpers"

class ApplicationController < Sinatra::Base
  helpers Helpers::Note
  # set folder for templates to ../views, but make the path absolute
  set :views, File.expand_path('../../views', __FILE__)

  get "/" do
    @notes = Note.build_notes
    haml :index
  end

  get "/about" do
    haml :about
  end
end
