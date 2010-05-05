require 'monitor'
class Cyberspace
  class Matrix
    # This might be somewhat of confusing, but this Client is the serverside
    # storage of the client's data.
    class Client
      include MonitorMixin

      # @param [Object] identifier of the Client
      # @param [String] language used
      # @param [Array<String>] libraries to load WARNING! sanitize them!
      # @param [String] code to load
      # @param [Matrix] the matrix this Client belongs to
      def initialize(identifier, lang, libs, code, matrix)
        @identifier, @lang, @libs, @code, @matrix = identifier, lang, libs, code, matrix
        clients.merge!(identifier => self)
        @lock = Mutex.new
      end

      attr_reader :identifier, :lang, :libs, :code, :jail, :matrix

      # @raise [NotImplementedError] in case the language is not supported
      def setup_jail
        if jail = Jails.const_get(lang.capitalize)
          client = self
          jail.new(@libs, @code, Class.new(Server) { self.client = self } )
        else
          raise NotImplementedError, "#{@lang} is not supported yet."
        end
      end

      # Let the fun begin!
      def enter_the_matrix
        self.jail = setup_jail
        jail.enter_the_matrix
      end

      # @return [EventMachine::Connection] connection to the client
      def connection
        jail.connection
      end

      # @param [Hash] send this hash to the Client
      def send_hash(hash)
        connection.send_hash(hash)
      end

      VALID_STATES = [:loading, :ready, :running, :stopping, :stopped]

      def state=(state)
        raise ArgumentError, "invalid state" unless VALID_STATES.include?(state)
        raise ThreadError, "state is being changed" unless mon_try_enter
        @state = state
        mon_exit
      end

      def state
        @state
      end

    end
  end
end
