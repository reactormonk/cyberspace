require 'eventmachine'
require_relative 'json_protocol'

module Cyberspace
  module Client
    include JSONProtocol

    def self.enter_the_matrix(client)
      EM::run do
        em = EM.attach($stdin, self)
        em.receiver = client
      end
    end

  end
end
