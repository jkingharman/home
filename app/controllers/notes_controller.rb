class NotesController < ApplicationController

  get "/notes" do
    @notes = Note.notes
    haml :notes
  end
end
