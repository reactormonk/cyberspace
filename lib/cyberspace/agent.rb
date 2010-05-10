require_relative 'json_protocol'

module Cyberspace
  module Agent
    include JSONProtocol

    # Attach self to stdin, so it can answer incoming requests.
    def self.enter_the_matrix
      EM::run do
        EM.attach($stdin, self)
      end
    end

    def post_init
    end

  end
end
