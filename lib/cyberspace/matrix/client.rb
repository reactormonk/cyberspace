# load all jails
File.chdir('../jails') do |dir|
  Dir['*.rb*'].each do |file|
    require file
  end
end

class Cyberspace
  class Matrix
    # This might be somewhat of confusing, but this Client is the serverside
    # storage of the client's data.
    class Client

      # Create a new Client. Data not checked for existence, be careful.
      # @option params [Object] 'id' id of the Client
      # @option params [String] 'lang' language used
      # @option params [Array<String>] 'libs' libraries to load WARNING! sanitize them!
      # @option params [String] 'code' code to load
      # @param [Matrix] matrix the matrix this Client belongs to
      def initialize(matrix, params={})
        @id, @lang, @libs, @code, @matrix = params['id'], params['lang'], params['libs'], params['code'], matrix
        @ready = false
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
      # @return [Class, Module] the EM server
      attr_reader :server
      # @return [Boolean] wherever the client is ready to run
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
