require 'monitor'
class Cyberspace
  class Matrix
    # This might be somewhat of confusing, but this Client is the serverside
    # storage of the client's data.
    class Client
      include MonitorMixin

      # @param [Hash] hash argument hash
      # @option hash [Object] 'id' id of the Client
      # @option hash [String] 'lang' language used
      # @option hash [Array<String>] 'libs' libraries to load WARNING! sanitize them!
      # @option hash [String] 'code' code to load
      # @param [Matrix] matrix the matrix this Client belongs to
      def initialize(hash, matrix)
        @id, @lang, @libs, @code, @matrix = hash['id'], hash['lang'], hash['libs'], hash['code'], matrix
      end

      # @return [Object] id of the Client
      attr_reader :id
      # @return [String] language used
      attr_reader :lang
      # @return [Array<String>] libraries to be loaded
      attr_reader :libs
      # @return [String] code to be loaded by the jail
      attr_reader :code
      # @return [Jails] the Jail this Client runs in
      attr_reader :jail
      # @return [Matrix] the matrix this Client belongs to
      attr_reader :matrix
      # @return [Class] the class running as server
      attr_reader :server
      # @return [true|nil] wherever the client is ready to run
      attr_reader :ready

      # @raise [NotImplementedError] in case the language is not supported
      # @return [Jails] the Jail this Client has been started in
      def setup_jail
        if Jails.const_defined?(lang.capitalize)
          jail = Jails.const_get(lang.capitalize)
          client = self
          @server = Module.new(Server) { self.client = client }
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

      # @param [Hash] hash send this hash to the Client
      def send_hash(hash)
        connection.send_hash(hash)
      end

    end
  end
end
