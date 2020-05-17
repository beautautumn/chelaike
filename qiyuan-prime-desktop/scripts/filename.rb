#!/usr/bin/env ruby
#
# 用来找出 class 名跟文件名不同的文件
#

files = Dir.glob("./src/**/*.js");

files.each do |file|
  fileName = File.basename(file);
  content = File.read(file)
  _, className = /(?<=class )(.+?) /.match(content).to_a
  if className and fileName != "#{className}.js"
    puts file
    puts className
  end
end
