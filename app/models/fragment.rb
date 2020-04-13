class Fragment < Sinatra::Base
  set :root, File.expand_path('../../..', __FILE__)

  def self.build(slug = nil)
    frags = []
    path = "#{settings.root}" + "/md/fragments/" + "#{slug ? slug : '*'}" + ".md"
    Dir.glob(path) {|file| frags << build_struct(file) }
    frags
  end

  private

  def self.build_struct(file)
    meta, content = File.read(file).split("\n\n", 2)
    frag = OpenStruct.new YAML.safe_load(meta)
    frag.content = Kramdown::Document.new(content).to_html
    frag.slug = File.basename(file, '.md')
    frag
  end
end
