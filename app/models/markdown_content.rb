class MarkdownContent < Sinatra::Base
  set :root, File.expand_path('../../..', __FILE__)

  def self.build(type, slug = nil)
    content = []
    path = "#{settings.root}" + "/md/#{type}/" + "#{slug ? slug : '*'}" + ".md"
    Dir.glob(path) {|file| content << build_struct(file) }
    content
  end

  private

  def self.build_struct(file)
    meta, content = File.read(file).split("\n\n", 2)
    content_struct = OpenStruct.new YAML.safe_load(meta)
    content_struct.content = Kramdown::Document.new(content).to_html
    content_struct.slug = File.basename(file, '.md')
    content_struct
  end
end
