class FragmentsController < ApplicationController
  set :root, File.expand_path('../../..', __FILE__)

  get "/fragments" do
    @page = params['page'].to_i || 0
    @frags = asc_order(Fragment.build)
    @frags = paginate(@frags, @page)

    # Go root if there are no fragments for a page.
    redirect "/" if @frags[:paginated].empty?
    haml :fragments
  end

  private

end
