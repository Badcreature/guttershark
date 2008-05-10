#!/usr/bin/env ruby -w
require 'rubygems'
require 'optparse'
OPTIONS = {}
OptionParser.new do |opts|
opts.banner = "
    New Flash Site - creates a skeleton for a new Guttershark Flash Site.
    Usage: plugout [OPTIONS]
    
    New flash site uses templates from the flashsites folder.
    
    USAGE EX: Create a new flash site.
      new-flash-site.rb -t notracking -l /users/aaronsmith/dev/projects/myFlashProjectName

    Commandline Switches Available:
      
" 
  opts.on("-l", "--location=/my/location", "The location to put the skeleton.") do |l|
    OPTIONS[:location] = l
  end
  opts.on("-t","--template=template1", "Which template from the flashsites folder to re-create.") do |p|
    OPTIONS[:template] = p.downcase
  end
  opts.on_tail("-h", "--help", "Show this usage statement.") do |h|
    OPTIONS[:exit] = true
    puts opts
    puts "\n"
  end
end.parse!
if OPTIONS[:exit]
  exit(0)
end

system("mkdir -p #{OPTIONS[:location]}")
system("cp -R ./flashsites/#{OPTIONS[:template]}/ #{OPTIONS[:location]}")