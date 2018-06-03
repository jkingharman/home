class NotesController < ApplicationController

  get "/notes/\*" do
    slug = request.path_info.gsub("/notes/","")
    @note = Note.build_note(slug)
    haml :note
  end

  get "/notes" do
    @notes = Note.build_notes
    haml :notes
  end
end
