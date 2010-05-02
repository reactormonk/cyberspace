require 'eventmachine'
require_relative 'json_protocol'

module Cyberspace
  module Agent
    include JSONProtocol

    def self.enter_the_matrix(agent)
      EM::run do
        em = EM.attach($stdin, self)
        em.receiver = agent
      end
    end

  end
end
