require "pry"
class NotesController < ApplicationController

  get "/notes" do
    @title = "Notes"
    @notes = Note.by_desc_year

    haml :notes
  end
end
