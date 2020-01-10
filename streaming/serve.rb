#!/usr/bin/env ruby

require 'bundler/inline'
require 'socket'

gemfile do
  source 'https://rubygems.org'
  gem 'rack', '1.6.12'
  gem 'goliath'
end

class Stream < Goliath::API
  def response(env)
    puts env['REMOTE_ADDR']
    socket = UNIXSocket.open('stream.flac')
    EM.add_periodic_timer(0.02) do
      env.stream_send(socket.recv_nonblock(100_000))
    rescue IO::EAGAINWaitReadable
    end

    [200, {}, Goliath::Response::STREAMING]
  end
end