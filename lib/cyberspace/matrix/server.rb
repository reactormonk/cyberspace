module Cyberspace
  class Matrix
    module Server
      include JSONProtocol

      # This method is called by the agent if it's finished loading
      def ready
        client.ready = true
        client.matrix.enter
      end

      protected
      # Client goes here
      class << self
        attr :client
      end

      def unbind
      end

    end
  end
end
