require_relative '../helpers/sort_helpers'

class ApplicationController < Sinatra::Base
  helpers Helpers::Sort
  # set folder for templates to ../views, but make the path absolute
  set :views, File.expand_path('../../views', __FILE__)

  # Haml 6+ escapes `=` output by default; these templates render trusted,
  # pre-rendered HTML (partials, Markdown), so restore Haml 5's non-escaping
  # default. Explicit escaping is still available via `&=`.
  set :haml, escape_html: false

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
    @tags = @content.map {|content| content.tags }.flatten.compact.uniq.sort
    haml :posts
  end

  get '/archive' do
    redirect "/"
    # @content = MarkdownContent.build(["notes"])
    # @tags = @content.map {|content| content.tags }.flatten.compact.uniq.sort
    # haml :archive
  end
end
