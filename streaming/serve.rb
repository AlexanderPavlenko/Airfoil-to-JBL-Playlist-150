#!/usr/bin/env ruby

require 'bundler/inline'
require 'socket'

gemfile do
  source 'https://rubygems.org'
  gem 'rack', '1.6.12'
  gem 'goliath'
end

class Stream < Goliath::API

  INPUT = UNIXSocket.open('stream.flac')
  
  def response(env)
    puts env['REMOTE_ADDR']
    EM.add_periodic_timer(0.01) do
      env.stream_send(INPUT.recv_nonblock(50_000))
    rescue IO::EAGAINWaitReadable
    end

    [200, {"Content-Type" => "audio/flac"}, Goliath::Response::STREAMING]
  end
end