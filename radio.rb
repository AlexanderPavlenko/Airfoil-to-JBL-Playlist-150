#!/usr/bin/env ruby

require 'bundler/inline'
require 'shellwords'

gemfile do
  source 'https://rubygems.org'
  gem 'tty-prompt'
end

CAST = 'Home'
MENU = begin
  m3u = File.read(File.expand_path('radio.m3u', __dir__)).each_line
  m3u.next # skip EXTM3U header
  result = {}
  index = 1
  loop do
    title = m3u.next.split(' - ', 2)[1]
    url = m3u.next
    result["#{index}. #{title.strip}"] = url.strip
    index += 1
  rescue StopIteration
    break result
  end
end

def cast(url)
  system %(./cast.py --to #{Shellwords.escape CAST} --url #{Shellwords.escape url} --type audio)
end

index = ARGV[0].to_i
if index > 0 && index <= MENU.size
  cast MENU.to_a[index - 1][1]
  exit
else
  prompt = TTY::Prompt.new
  loop do
    cast prompt.select('Which one?', MENU, filter: true, help: '')
  rescue TTY::Reader::InputInterrupt
    exit
  end
end
