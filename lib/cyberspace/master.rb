module Cyberspace
  class Master < EM::Connection

    # @param [Hash] data for the new client
    def add_client(hash)
      Server.agents << Server::Client.new(hash)
    end

  end
end
