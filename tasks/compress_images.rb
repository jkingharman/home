# tasks/compress_images.rb — generate the compressed + blurred variants that
# the galleries lazy-load. Called automatically by build.rb; also runnable
# standalone:
#
#   bundle exec ruby tasks/compress_images.rb
#
# For each full-resolution photo <name>.jpg in a gallery folder under
# assets/images/<gallery>/, it produces (only if missing):
#
#   <name>-compress.jpg       compressed; swapped in by lazy_load_images.js
#   <name>-compress-blur.jpg  tiny blurred placeholder shown first
#
# Existing variants are left untouched, so re-running is cheap — only new photos
# do any work. Requires ImageMagick (`brew install imagemagick` locally; CI's
# ubuntu runner has it).

require "mini_magick"

module CompressImages
  IMAGES_ROOT = File.expand_path("../assets/images", __dir__)

  module_function

  def run(root = IMAGES_ROOT)
    generated = 0

    Dir.glob(File.join(root, "*")).select { |f| File.directory?(f) }.each do |dir|
      Dir.glob(File.join(dir, "*.jpg")).each do |src|
        base = File.basename(src, ".jpg")
        next if base.end_with?("-compress", "-compress-blur") # already a variant

        compressed = File.join(dir, "#{base}-compress.jpg")
        blurred    = File.join(dir, "#{base}-compress-blur.jpg")
        next if File.exist?(compressed) && File.exist?(blurred)

        compress(src, compressed)  unless File.exist?(compressed)
        blur(compressed, blurred)  unless File.exist?(blurred)
        generated += 1
        puts "image  #{File.basename(dir)}/#{base}.jpg -> compress + blur"
      end
    end

    puts "generated variants for #{generated} new photo(s)" if generated.positive?
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

  # Tiny blurred placeholder: downscale hard then blur, so the first paint is
  # cheap. The browser scales it up; lazy_load_images.js later swaps in the
  # sharp compressed version by stripping "-blur" from the filename.
  def blur(src, dest)
    image = MiniMagick::Image.open(src)
    image.combine_options do |c|
      c.resize "120x"
      c.blur "0x8"
      c.quality "40"
    end
    image.write(dest)
  end
end

CompressImages.run if __FILE__ == $PROGRAM_NAME
