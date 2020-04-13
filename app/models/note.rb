class Note < Sinatra::Base
  set :root, File.expand_path('../../..', __FILE__)

  def self.build(slug = nil)
    notes = []
    path = "#{settings.root}" + "/md/notes/" + "#{slug ? slug : '*'}" + ".md"
    Dir.glob(path) {|file| notes << build_struct(file) }
    notes
  end

  private

  def self.build_struct(file)
    meta, content = File.read(file).split("\n\n", 2)
    note = OpenStruct.new YAML.safe_load(meta)
    note.content = Kramdown::Document.new(content).to_html
    note.slug = File.basename(file, '.md')
    note
  end
end
