require_relative 'json_protocol'

module Cyberspace
  # Protocol JSON
  #
  # Basic Parameters (may be added to each request):
  #
  # wait (True or False):
  #   determines wherever to wait if not enough AP are avaible or send
  #   an error message back
  #
  module Server
    include JSONProtocol

    def post_init
    end

    def unbind
    end

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
      end

      attr_reader :identifier, :lang, :libs, :code, :jail, :ready

      # @raise [NotImplementedError] in case the language is not supported
      def setup_jail
        if jail = Jails.const_get(lang.capitalize)
          jail.new(@libs, @code)
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

    end

  end
end
