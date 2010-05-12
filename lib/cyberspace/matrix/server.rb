module Cyberspace
  class Matrix
    module Server
      include JSONProtocol

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
