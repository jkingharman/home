
class FragmentsController < ApplicationController
  set :root, File.expand_path('../../..', __FILE__)

  get "/fragments" do
    @notes = Note.build
    @notes = Kaminari.paginate_array(@notes).page(1).per(5)
    haml :fragments
  end

  private

end
