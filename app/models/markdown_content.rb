require "ostruct"
require "yaml"
require "kramdown"

class MarkdownContent
  ROOT = File.expand_path("../..", __dir__)

  def self.build(types, slug = nil)
    content = []
    types.each do |type|
      path = "#{ROOT}/md/#{type}/#{slug ? slug : '*'}.md"
      Dir.glob(path) {|file| content << build_struct(file, type) }
    end
    content
  end

  private

  def self.build_struct(file, type)
    meta, content = File.read(file).split("\n\n", 2)
    content_struct = OpenStruct.new YAML.safe_load(meta)
    content_struct.type = type
    content_struct.content = Kramdown::Document.new(content).to_html
    content_struct.slug = File.basename(file, '.md')

    unless content_struct.tags.nil?
      content_struct.tags = content_struct.tags&.split(",").flatten.compact.map(&:strip).uniq.sort
    end

    content_struct
  end
end
