class NotesController < ApplicationController

  # candidate for extraction?
  helpers do
    def truncate(note_content)
      note_content[0...180] + "..."
    end
  end

  get "/notes/\*" do
    slug = request.path_info.gsub("/notes/","")
    @note = Note.build_note(slug)
    haml :note
  end
end
