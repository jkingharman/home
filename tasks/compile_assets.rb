# tasks/compile_assets.rb — compile SCSS/JS into committed static assets.
#
#   bundle exec ruby tasks/compile_assets.rb
#
# Replaces the old Sprockets pipeline. Run this only when you change something
# under assets/stylesheets or assets/javascripts, then commit the regenerated
# public/assets/app.css and public/assets/app.js. The site itself just serves
# those two files as-is.
#
# This mirrors the old `//= require_tree` behaviour: every file in each
# directory is compiled/included independently, in alphabetical order, and
# concatenated. (Sprockets compiled each SCSS file in its own scope too, so
# there are no cross-file variable/@import dependencies to preserve.)

require "sassc"
require "fileutils"

ROOT   = File.expand_path("..", __dir__)
OUT    = File.join(ROOT, "public", "assets")
STYLES = File.join(ROOT, "assets", "stylesheets")
SCRIPT = File.join(ROOT, "assets", "javascripts")

FileUtils.mkdir_p(OUT)

# --- CSS ---------------------------------------------------------------------
css = Dir.children(STYLES).sort.map do |file|
  path = File.join(STYLES, file)
  if file.end_with?(".scss")
    SassC::Engine.new(File.read(path), style: :compressed).render
  else # plain .css (e.g. materialize.min.css) passes through untouched
    File.read(path)
  end
end.join("\n")

File.write(File.join(OUT, "app.css"), css)
puts "wrote public/assets/app.css"

# --- JS ----------------------------------------------------------------------
# Concatenate in alphabetical order.
js = Dir.children(SCRIPT).sort.map do |file|
  File.read(File.join(SCRIPT, file))
end.join("\n")

File.write(File.join(OUT, "app.js"), js)
puts "wrote public/assets/app.js"
