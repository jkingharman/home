source "https://rubygems.org"

ruby "3.4.9"

# Build: build.rb renders the Markdown notes through Haml templates to static
# HTML — no web framework involved.
gem "haml"
gem "kramdown" # Markdown -> HTML
gem "rouge"    # syntax highlighting (kramdown's default highlighter)
gem "ostruct"      # leaving Ruby's default gems in 4.0; used by MarkdownContent
gem "mini_magick"  # gallery image variants at build time, see tasks/compress_images.rb

group :development do
  gem "sassc"   # one-off SCSS -> CSS compilation, see tasks/compile_assets.rb
  gem "webrick" # local preview server, see tasks/preview.rb
end
