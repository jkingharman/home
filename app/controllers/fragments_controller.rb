class FragmentsController < ApplicationController
  set :root, File.expand_path('../../..', __FILE__)

  get "/fragments" do
    @page = params['page'].to_i || 0
    @frags = asc_posted_at(MarkdownContent.build(["fragments"]))
    @frags = paginate(@frags, @page)

    # Go root if there are no fragments for a page.
    redirect "/" if @frags[:paginated].empty?
    haml :fragments
  end

  get "/fragments/\*" do
    slug = request.path_info.gsub('/fragments/', '')
    @fragment = MarkdownContent.build(["fragments"], slug).first
    haml :fragment
  end

end
