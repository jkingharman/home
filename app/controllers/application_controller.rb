
require './config/environments'
require 'time'

class ApplicationController < Sinatra::Base
  # set folder for templates to ../views, but make the path absolute
  set :views, File.expand_path('../../views', __FILE__)

  get "/" do
    @notes = Note.build_notes
    @notes.sort! { |x,y| Date.parse(x.date) <=> Date.parse(y.date) }.reverse!

        # @notes = @notes.sort_by(&:date)
    haml :index
  end
end
