#!/usr/bin/env ruby
# frozen_string_literal: true

require 'shellwords'
require 'tty-prompt'

CAST_TO = ENV.fetch('CAST_TO', 'Home')
MENU    =
  begin
    m3u = File.read(File.expand_path('radio.m3u', __dir__.to_s)).each_line
    m3u.next # skip EXTM3U header
    result = {}
    index  = 1
    loop do
      title                              = m3u.next.split(' - ', 2)[1]
      url                                = m3u.next
      result["#{index}. #{title.strip}"] = url.strip

      index += 1
    rescue StopIteration
      break result
    end
  end

def cast(url)
  Dir.chdir(__dir__.to_s) do
    system %(pipenv run ./cast.py --to #{Shellwords.escape CAST_TO} --url #{Shellwords.escape url} --type audio)
  end
end

index = ARGV[0].to_i
if index.positive? && index <= MENU.size
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
