module Cyberspace
  module Matrix
    # This class is subclasses using Class.new to create responders.
    class Server
      include JSONProtocol

      # JSON callable methods go here

      protected
      # The associated client
      class << self
        attr :client
      end

      def post_init
      end

      def unbind
      end

    end
  end
end
