#!/usr/bin/env ruby

require 'bundler/inline'
require 'shellwords'
require 'yaml'
gemfile do
  source 'https://rubygems.org'
  gem 'tty-prompt'
end

LIST = YAML.load_file(File.expand_path('radio.yml', __dir__))
CAST = 'Home'

def cast(stream)
  system %(./cast.py --to #{Shellwords.escape CAST} --url #{Shellwords.escape stream['url']} --type #{Shellwords.escape stream['type']})
end

index = ARGV[0].to_i
if index > 0 && index <= LIST.size
  cast LIST[index - 1]
  exit
else
  prompt = TTY::Prompt.new
  menu = Hash[LIST.map { |e| [e['name'], e] }]
  loop do
    cast prompt.select('Which one?', menu, filter: true, help: '')
  rescue TTY::Reader::InputInterrupt
    exit
  end
end
