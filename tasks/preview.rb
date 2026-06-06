# tasks/preview.rb — local preview of ./build that mimics GitHub Pages.
#
#   bundle exec ruby tasks/preview.rb   # then open http://localhost:8000
#
# A plain static server won't resolve the extensionless URLs the templates use
# (e.g. /about, /notes/brexit). GitHub Pages maps those to about.html etc.;
# this server does the same so local preview matches production.

require "webrick"

ROOT = File.expand_path("../build", __dir__)

TYPES = {
  ".html" => "text/html; charset=utf-8", ".css" => "text/css; charset=utf-8",
  ".js" => "application/javascript; charset=utf-8",
  ".png" => "image/png", ".jpg" => "image/jpeg", ".jpeg" => "image/jpeg",
  ".svg" => "image/svg+xml", ".woff2" => "font/woff2", ".woff" => "font/woff",
}.freeze

server = WEBrick::HTTPServer.new(Port: 8000, DocumentRoot: ROOT)

server.mount_proc "/" do |req, res|
  path = File.join(ROOT, req.path)
  path = File.join(path, "index.html") if File.directory?(path)
  path = "#{path}.html" if !File.file?(path) && File.file?("#{path}.html")

  if File.file?(path)
    res.body = File.binread(path)
    res["Content-Type"] = TYPES.fetch(File.extname(path), "application/octet-stream")
  else
    res.status = 404
  end
end

trap("INT") { server.shutdown }
server.start
