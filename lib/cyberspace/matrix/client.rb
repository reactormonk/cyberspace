require 'monitor'
require 'state_machine'
class Cyberspace
  class Matrix
    # This might be somewhat of confusing, but this Client is the serverside
    # storage of the client's data.
    class Client
      include MonitorMixin

      state_machine(initial: :loading) do

        event :ready do
          transition :loading => :ready
        end

        after_transition to: :ready do |client, transition|
          client.matrix.ready
          true
        end

      end

      # @param [Object] identifier of the Client
      # @param [String] language used
      # @param [Array<String>] libraries to load WARNING! sanitize them!
      # @param [String] code to load
      # @param [Matrix] the matrix this Client belongs to
      def initialize(identifier, lang, libs, code, matrix)
        @identifier, @lang, @libs, @code, @matrix = identifier, lang, libs, code, matrix
        clients.merge!(identifier => self)
        @state = :loading
      end

      attr_reader :identifier, :lang, :libs, :code, :jail, :matrix, :server

      # @raise [NotImplementedError] in case the language is not supported
      def setup_jail
        if jail = Jails.const_get(lang.capitalize)
          client = self
          @server = Class.new(Server) { self.client = self }
          jail.new(@libs, @code, @server)
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

    end
  end
end
