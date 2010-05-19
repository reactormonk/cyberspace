require_relative '../json_protocol'

module Cyberspace
  class Matrix
    module Server
      include JSONProtocol

      # This method is called by the agent if it's finished loading
      # @return true
      def ready
        client.ready = true
        client.matrix.enter
        true
      end

      class << self
        # Client goes here
        attr :client
      end

      # @see EventMachine::Connection
      def unbind
        # TODO logger here
        client.matrix.remove_client(client.id)
      end

      protected
      # @see EventMachine::Connection
      # Setting up a Timebomb to kill the client if it hasn't loaded within 20s.
      def post_init
        EM::add_timer(20) do
          unless client.ready
            # TODO logger here
            close_connection
          end
        end
      end

    end
  end
end
