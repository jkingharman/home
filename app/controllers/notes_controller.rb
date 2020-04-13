class NotesController < ApplicationController
  set :root, File.expand_path('../../..', __FILE__)

  before "/notes\*" do
    redirect "/" unless note_exist?
  end

  get "/notes/\*" do
    slug = request.path_info.gsub('/notes/', '')
    @note = Note.build(slug).first
    haml :note
  end

  private

  def note_exist?
    File.exist? "#{settings.root}/md/#{request.path}.md"
  end
end
