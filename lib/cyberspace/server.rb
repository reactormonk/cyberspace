require 'eventmachine'
require_relative 'json_protocol'

module CyberSpace
  # Protocol JSON
  #
  # Basic Parameters (may be added to each request):
  #
  # wait (True or False):
  #   determines wherever to wait if not enough AP are avaible or send
  #   an error message back
  #
  module Server
    include JSONProtocol

    def post_init
    end

    def receive_json(json)
    end

    def unbind
    end

  end
end
