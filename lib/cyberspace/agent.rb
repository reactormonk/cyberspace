require 'eventmachine'
require_relative 'json_protocol'

module CyberSpace
  module Agent
    include JSONProtocol

    def post_init
    end

    def receive_hash(hash)
    end

  end
end
