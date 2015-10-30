#!/usr/bin/env ruby

# Description: Originally written to bulk convert aac files to mp3
# Author:      Shane Reddy
# Date:        30/10/2015

require 'optparse'
require 'mkmf'
require 'shellwords'

command = find_executable 'ffmpeg'
fail "ffmpeg not installed" unless command

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: bulk_convert_to_mp3.rb [options]"

  opts.on("-pPATH", "Path to read audio files")             { |n| options[:path] = n }
  opts.on("-eEXT", "File extension of the file to convert") { |n| options[:ext] = n }
  opts.on("-d", "--[no-]dry-run", "Dry Run")                { |n| options[:dry] = n }

end.parse!

# Parse the directory where your files are stored
Dir.entries(options[:path]).each do |filename|
 next if filename !~ /#{options[:ext]}$/

 basename = File.basename filename, '.aac'
 converted_filename = basename + '.mp3'

 convert_command = "#{command} -i \
 #{Shellwords.escape options[:path]}/#{Shellwords.escape(filename)} \
 #{Shellwords.escape options[:path]}/#{Shellwords.escape converted_filename}"

 if options[:dry]
  puts convert_command
 else
  `#{convert_command}`
 end

end