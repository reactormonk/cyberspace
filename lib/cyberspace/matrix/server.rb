module Cyberspace
  class Matrix
    module Server
      include JSONProtocol

      def ready
        # reimplement
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
