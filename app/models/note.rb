class Note < Sinatra::Base
  set :root, File.expand_path("../../..", __FILE__)

  def self.notes
    notes = []
    Dir.glob "#{settings.root}/notes/\*.md" do |file|
      meta, content = File.read(file).split("\n\n", 2)

      note = OpenStruct.new YAML.load(meta)
      note.content = content
      note.slug = File.basename(file, ".md")
      notes << note
    end
    notes
  end
end
