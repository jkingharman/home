class Skate < Sinatra::Base
  set :root, File.expand_path("../../..", __FILE__)
  SK8_PATH = "#{settings.root}/skate/skate.md"

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

    sk8_struct.type = sk8_item.first
    sk8_struct.url = sk8_item[1]
    sk8_struct.date = sk8_item[2]
    sk8_struct.comment = sk8_item[3]
    sk8_struct
  end
end
