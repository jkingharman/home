require 'kramdown' # remove if needed

module Helpers
  module Markdown
    def render_markdown(str)
      Kramdown::Document.new(str).to_html
    end
  end
end
