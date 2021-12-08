require_relative '../helpers/sort_helpers'

class ApplicationController < Sinatra::Base
  helpers Helpers::Sort
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
    # redirect "/"
    haml :about
  end

  get '/contact' do
    haml :contact
  end

  get '/posts' do
    @content = MarkdownContent.build(["notes"])
    haml :posts
  end

  get '/archive' do
    redirect "/"
    # @content = MarkdownContent.build(["notes"])
    # @tags = @content.map {|content| content.tags }.flatten.compact.uniq.sort
    # haml :archive
  end
end
