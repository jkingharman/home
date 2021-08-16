require "mozjpeg"
require 'mini_magick'

abort("mozJPEG not supported") unless Mozjpeg.supported?

Dir.chdir('../assets/images')
# Every top-level folder in /images should hold images
img_dirs = Dir.glob("*").select {|f| File.directory? f }

img_dirs.each do |dir|
  Dir.entries(dir).each do |img|
    ext_name = File.extname(img)
    base_name = File.basename(img, ".jpg")
    next if ext_name != ".jpg" || base_name.match?("-compress") || Dir.entries(dir).include?("#{base_name}-compress-blur.jpg")


    # Go down to make system call for compressed placeholder
    Dir.chdir(dir)
    `touch #{base_name}-compress.jpg`

    in_path = File.new(img)
    out_path = File.new("#{base_name}-compress.jpg")
    Mozjpeg.compress in_path, out_path, arguments: '-quality 70 -quant-table 2 -notrellis'

    # create the blurred version for lazy loading too
    MiniMagick::Tool::Convert.new do |convert|
      convert << "#{base_name}-compress.jpg"
      convert.blur("0x100")
      convert << "#{base_name}-compress-blur.jpg"
    end

    Dir.chdir("..")
  end
end
