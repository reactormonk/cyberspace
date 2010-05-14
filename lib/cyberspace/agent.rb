require_relative 'json_protocol'

module Cyberspace
  module Agent
    include JSONProtocol

    # Attach self to stdin, so it can answer incoming requests.
    # Add <youragent>.enter_the_matrix at the end of your code.
    def self.enter_the_matrix
      EM::run do
        EM.attach($stdin, self)
      end
    end

    def post_init
      send_hash(:action => :ready)
    end

  end
end
