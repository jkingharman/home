require_relative '../helpers/sort_helpers'
require_relative '../helpers/paginate_helpers'

class ApplicationController < Sinatra::Base
  helpers Helpers::Sort, Helpers::Paginate
  # set folder for templates to ../views, but make the path absolute
  set :views, File.expand_path('../../views', __FILE__)

  not_found do
    redirect "/"
  end

  get '/' do
    @notes = MarkdownContent.build(["notes"])

    haml :index
  end

  get '/about' do
    haml :about
  end

  get '/archive' do
    @content = MarkdownContent.build(["notes", "scraps"])
    @tags = @content.map {|content| content.tags&.split(",") }.flatten.compact.map(&:strip).uniq.sort

    haml :archive
  end
end
