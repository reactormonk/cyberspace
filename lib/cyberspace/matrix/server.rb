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

      protected
      class << self
        # Client goes here
        attr :client
      end

      def unbind
      end

    end
  end
end
