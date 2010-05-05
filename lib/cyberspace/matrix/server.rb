module Cyberspace
  class Matrix
    class Server < BasicObject
      include JSONProtocol

      undef :instance_eval, :instance_exec

      def ready(state)
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
