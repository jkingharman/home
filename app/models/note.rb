class Note < Sinatra::Base
  set :root, File.expand_path("../../..", __FILE__)

  def self.build_note(slug)
    note = ''
    Dir.glob "#{settings.root}/notes/#{slug}.md" do |file|
      note = build_struct(file)
    end
    note
  end

  def self.build_notes
    notes = []
    Dir.glob "#{settings.root}/notes/\*.md" do |file|
      notes << build_struct(file)
    end
    notes
  end

  def self.build_struct(file)
    meta, content = File.read(file).split("\n\n", 2)
    note = OpenStruct.new YAML.load(meta)
    note.content = content
    note.slug = File.basename(file, ".md")
    note
  end
end
