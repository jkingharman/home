# tasks/compress_images.rb — generate the compressed variants the galleries
# serve. An authoring-time task: run it after dropping new photos into
# assets/images/<gallery>/, commit the variants, then delete the originals
# (only -compress.jpg files are deployed).
#
#   bundle exec ruby tasks/compress_images.rb
#
# For each full-resolution <name>.jpg it produces <name>-compress.jpg
# (only if missing), so re-running is cheap. Requires ImageMagick
# (`brew install imagemagick`).

require "mini_magick"

module CompressImages
  IMAGES_ROOT = File.expand_path("../assets/images", __dir__)

  module_function

  def run(root = IMAGES_ROOT)
    generated = 0

    Dir.glob(File.join(root, "*")).select { |f| File.directory?(f) }.each do |dir|
      Dir.glob(File.join(dir, "*.jpg")).each do |src|
        base = File.basename(src, ".jpg")
        next if base.end_with?("-compress") # already a variant

        compressed = File.join(dir, "#{base}-compress.jpg")
        next if File.exist?(compressed)

        compress(src, compressed)
        generated += 1
        puts "image  #{File.basename(dir)}/#{base}.jpg -> #{base}-compress.jpg"
      end
    end

    puts "generated #{generated} new variant(s)"
  rescue Errno::ENOENT, MiniMagick::Error => e
    abort "Image processing failed — is ImageMagick installed? (`brew install imagemagick`)\n#{e.message}"
  end

  # Compressed full-size version: strip metadata, quality 70, progressive.
  def compress(src, dest)
    image = MiniMagick::Image.open(src)
    image.combine_options do |c|
      c.strip
      c.quality "70"
      c.interlace "Plane"
    end
    image.write(dest)
  end
end

CompressImages.run if __FILE__ == $PROGRAM_NAME
