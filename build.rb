# build.rb — render the site to static HTML in ./build
#
# Reads the Markdown under md/notes/, renders every page through the Haml
# templates in app/views (see lib/renderer.rb), and copies the compiled assets
# alongside. The ./build directory it produces is the entire website, ready to
# deploy to GitHub Pages.
#
#   bundle exec ruby build.rb

require "fileutils"
require "rouge" # kramdown picks it up as the syntax highlighter when loaded

require_relative "app/models/markdown_content"
require_relative "app/presenters/scrap"
require_relative "lib/renderer"

ROOT  = File.expand_path(__dir__)
BUILD = File.join(ROOT, "build")

# Generate compressed + blurred variants for any new gallery photos before
# rendering, so the presenter picks up the -compress-blur placeholders.
require_relative "tasks/compress_images"
CompressImages.run

notes = MarkdownContent.build(["notes"])
tags  = notes.map {|note| note.tags }.flatten.compact.uniq.sort

# Map clean URLs to flat files. Flat files (e.g. notes/foo.html, not
# notes/foo/index.html) preserve the existing /posts and /notes/<slug> URLs
# AND keep the templates' relative links (href="notes/foo") resolving from the
# site root. Directory-style output would break those links.
pages = {
  "/"        => ["index.html",   :index,   { notes: notes }],
  "/about"   => ["about.html",   :about,   {}],
  "/contact" => ["contact.html", :contact, {}],
  "/posts"   => ["posts.html",   :posts,   { content: notes, tags: tags }],
}

notes.each do |note|
  pages["/notes/#{note.slug}"] = ["notes/#{note.slug}.html", :note, { note: note }]
end

FileUtils.rm_rf(BUILD)
FileUtils.mkdir_p(BUILD)

pages.each do |path, (out, template, assigns)|
  html = Renderer.new(path, assigns).render_page(template)
  dest = File.join(BUILD, out)
  FileUtils.mkdir_p(File.dirname(dest))
  File.write(dest, html)
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

# Bind the custom domain on every deploy. The Actions-based Pages flow serves
# the artifact verbatim and does not inject a CNAME, so without this file each
# publish drops the domain binding and restarts TLS cert provisioning.
File.write(File.join(BUILD, "CNAME"), "www.jaskh.net\n")

# Drop any macOS cruft that got copied in.
Dir.glob(File.join(BUILD, "**", ".DS_Store")).each { |f| File.delete(f) }

puts "\nBuilt #{pages.size} pages into #{BUILD}"
