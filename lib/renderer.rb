# lib/renderer.rb — render the Haml templates in app/views without a web
# framework. Mirrors how Sinatra rendered them: templates run with this object
# as scope, so the assigns become instance variables (@notes, @note, ...) and
# partials render via the same `haml :name` helper the views already use.

require "haml"

require_relative "../app/helpers/sort_helpers"

class Renderer
  VIEWS = File.expand_path("../app/views", __dir__)

  include Helpers::Sort

  def initialize(current_path, assigns = {})
    @current_path = current_path
    assigns.each { |name, value| instance_variable_set("@#{name}", value) }
  end

  # The page's URL path; replaces Sinatra's request.path in the templates.
  attr_reader :current_path

  # Sinatra-style render helper, e.g. `haml :_nav_footer` in a view.
  def haml(name, locals: {})
    template(name).render(self, locals)
  end

  def render_page(name)
    template(:layout).render(self) { haml(name) }
  end

  private

  def template(name)
    # Haml 6+ escapes `=` output by default; these templates render trusted,
    # pre-rendered HTML (partials, Markdown), so keep Haml 5's non-escaping
    # behaviour. Explicit escaping is still available via `&=`.
    Haml::Template.new(File.join(VIEWS, "#{name}.haml"), escape_html: false)
  end
end
