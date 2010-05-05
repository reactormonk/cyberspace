module Cyberspace
  module Matrix
    # This might be somewhat of confusing, but this Client is the serverside
    # storage of the client's data.
    class Client

      # References to clients are stored here.
      class << self
        attr_reader :clients
      end
      self.clients = {}

      # @param [Object] identifier of the Agent (preferably integer)
      # @param [String] language used
      # @param [Array<String>] libraries to load WARNING! sanitize them!
      # @param [String] code to load
      def initialize(identifier, lang, libs, code)
        @identifier, @lang, @libs, @code = identifier, lang, libs, code
        clients.merge!(identifier => self)
        @lock = Mutex.new
      end

      attr_reader :identifier, :lang, :libs, :code, :jail

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

      # @return [EM::Connection] connection to the client
      def connection
        jail.connection
      end

      VALID_STATES = [:loading, :ready, :running, :stopping, :stopped]

    end
  end
end
