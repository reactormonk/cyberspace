require_relative 'json_protocol'

module Cyberspace
  module Agent
    include JSONProtocol

    def initialize
    end

    def self.enter_the_matrix(client)
      EM::run do
        EM.attach($stdin, self)
      end
    end

    def post_init
    end

  end
end
