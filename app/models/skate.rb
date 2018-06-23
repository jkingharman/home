class Skate < Sinatra::Base
  set :root, File.expand_path("../../..", __FILE__)
  SK8_PATH = "#{settings.root}/skate/skate.md".freeze
  STRUCT_PROPERTIES = [
    "type",
    "url",
    "date",
    "height",
    "width",
    "comment"
  ]

  def self.build_structs
    sk8_items = read_sk8_items
    sk8_items.map { |item| build_struct(item) }
  end

  private

  def self.read_sk8_items
    each_sk8_item = File.read(SK8_PATH).split("\n\n")
    each_sk8_item.map {|item| item.split("\n") }
  end

  def self.build_struct(sk8_item)
    sk8_struct = OpenStruct.new

    STRUCT_PROPERTIES.each_with_index do |property, i|
      sk8_struct[property] = sk8_item[i]
    end
    sk8_struct
  end
end
