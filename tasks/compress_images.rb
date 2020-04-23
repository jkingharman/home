require "mozjpeg"

abort("mozJPEG not supported") unless Mozjpeg.supported?

Dir.chdir('./assets/images')

# Every top-level folder in /images should hold images
img_dirs = Dir.glob("*").select {|f| File.directory? f }

puts `pwd`

img_dirs.each do |dir|
  # puts `ls`
  Dir.entries(dir).each do |img|
  #   puts img
  #   ext_name = File.extname(img)
  #   base_name = File.basename(img, ".jpg")
  #   next if ext_name != ".jpg" || base_name.match?("-compress")
  #
  #   # Go down to make system call for compressed placeholder
    Dir.chdir(dir)
    `touch test.txt`
    puts `ls`

  #   puts `pwd`
  #
  #   `touch #{base_name}-compress.jpg`
  #
  #   in_path = File.new(img)
  #   out_path = File.new("#{base_name}-compress.jpg")
  #   Mozjpeg.compress in_path, out_path, arguments: '-quality 70 -quant-table 2 -notrellis'

    Dir.chdir("..")
  end
end
