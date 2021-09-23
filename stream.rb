#!/usr/bin/env ruby
# frozen_string_literal: true

require 'goliath'

class Stream < Goliath::API
  BUFFER      = +''
  BUFFER_SIZE = 1_000_000
  BUFFERING   =
    Thread.new do
      loop do
        BUFFER << $stdin.read(9000).to_s
      end
    end

  def response(env)
    warn env['REMOTE_ADDR']
    buffering
    EM.add_periodic_timer(1) do
      data_size = BUFFER.size
      # warn data_size
      env.stream_send BUFFER[0...data_size].to_s
      BUFFER[0...data_size] = ''
    end

    [200, { 'Content-Type' => 'audio/wav' }, Goliath::Response::STREAMING]
  end

  private

  def buffering
    while BUFFER.size < BUFFER_SIZE
      warn "buffering #{(BUFFER.size.to_f / BUFFER_SIZE * 100).to_i}%"
      sleep 1
    end
  end
end
