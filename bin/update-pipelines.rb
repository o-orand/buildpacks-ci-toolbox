#!/usr/bin/env ruby
# encoding: utf-8

require 'yaml'

flyrc  = YAML.load_file(File.expand_path('~/.flyrc'))
target_name="concourse-cw"
target = flyrc['targets'][target_name]

def header(msg)
  print '*' * 10
  puts " #{msg}"
end

def set_pipeline(target_name:,name:, cmd:, load: [])
  puts system(%{bash -c "fly -t #{target_name} set-pipeline \
    -p #{name} \
    -c <(#{cmd}) \
    -l public-credentials.yml \
    -l private.yml \
    #{load.collect { |l| "-l #{l}" }.join(' ')}
  "})
end

header('For pipelines')
Dir['pipelines/*.yml'].each do |filename|
  name = File.basename(filename, '.yml')
  puts "   #{name} pipeline"
  set_pipeline(target_name: target_name,name: name, cmd: "erb #{filename}")
end

puts 'Done'
