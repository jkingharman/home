class ScrapsController < ApplicationController
  set :root, File.expand_path('../../..', __FILE__)

  get "/scraps" do
    @page = params['page'].to_i || 0
    @scraps = asc_posted_at(MarkdownContent.build(["scraps"]))
    @scraps = paginate(@scraps, @page)

    # Go root if there are no scraps for a page.
    redirect "/" if @scraps[:paginated].empty?
    haml :scraps
  end

  get "/scraps/\*" do
    slug = request.path_info.gsub('/scraps/', '')
    @scrap = MarkdownContent.build(["scraps"], slug).first
    haml :scrap
  end

end
