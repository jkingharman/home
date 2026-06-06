# build.rb — render the Sinatra app to a static site in ./build
#
# Boots the real Rack app from config.ru and "freezes" every page to a flat
# HTML file, then copies the compiled assets alongside. The ./build directory
# it produces is the entire website, ready to deploy to GitHub Pages.
#
#   bundle exec ruby build.rb
#
# Nothing here is Heroku- or Pages-specific; it just turns the dynamic app into
# static files by asking it for every page once, up front.

ENV["RACK_ENV"] = "production"

require "rack"
require "rack/mock"
require "fileutils"

ROOT  = File.expand_path(__dir__)
BUILD = File.join(ROOT, "build")

# Boot the same Rack stack config.ru runs in production.
app = Rack::Builder.parse_file(File.join(ROOT, "config.ru"))
app = app.first if app.is_a?(Array) # Rack 2 returns [app, options]; Rack 3 returns app
server = Rack::MockRequest.new(app)

# Generate compressed + blurred variants for any new gallery photos before
# rendering, so the presenter picks up the -compress-blur placeholders.
require_relative "tasks/compress_images"
CompressImages.run

def fetch(server, path)
  res = server.get(path)
  abort "FAILED #{path} -> HTTP #{res.status}" unless res.status == 200
  res
end

# Map clean URLs to flat files. Flat files (e.g. notes/foo.html, not
# notes/foo/index.html) preserve the existing /posts and /notes/<slug> URLs
# AND keep the templates' relative links (href="notes/foo") resolving from the
# site root. Directory-style output would break those links.
pages = {
  "/"        => "index.html",
  "/about"   => "about.html",
  "/contact" => "contact.html",
  "/posts"   => "posts.html",
}

# One page per note (non-recursive glob, so md/notes/archived is skipped —
# matching MarkdownContent.build, which only globs md/notes/*.md).
Dir.glob(File.join(ROOT, "md/notes/*.md")).each do |file|
  slug = File.basename(file, ".md")
  pages["/notes/#{slug}"] = "notes/#{slug}.html"
end

FileUtils.rm_rf(BUILD)
FileUtils.mkdir_p(BUILD)

pages.each do |path, out|
  res  = fetch(server, path)
  dest = File.join(BUILD, out)
  FileUtils.mkdir_p(File.dirname(dest))
  File.write(dest, res.body)
  puts "page  #{path} -> #{out}"
end

# Everything in public/ is served from the site root. This includes the
# precompiled public/assets/app.css and app.js (see tasks/compile_assets.rb)
# and the fonts under public/fonts.
FileUtils.cp_r(File.join(ROOT, "public/."), BUILD)

# Images live under assets/images and are referenced as /assets/<...>
# (e.g. /assets/favi.png, /assets/<slug>/<img>.jpg); copy them into build/assets.
FileUtils.cp_r(File.join(ROOT, "assets/images/."), File.join(BUILD, "assets"))

# Stop GitHub Pages from running its own Jekyll build over our finished HTML.
File.write(File.join(BUILD, ".nojekyll"), "")

# Drop any macOS cruft that got copied in.
Dir.glob(File.join(BUILD, "**", ".DS_Store")).each { |f| File.delete(f) }

puts "\nBuilt #{pages.size} pages into #{BUILD}"
