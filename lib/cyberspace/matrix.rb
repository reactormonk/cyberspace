require_relative 'json_protocol'
require_relative 'matrix/server'
require_relative 'matrix/client'

module Cyberspace
  # Protocol JSON
  #
  # Basic Parameters (may be added to each request):
  #
  # wait (True or False):
  #   determines wherever to wait if not enough AP are avaible or send
  #   an error message back
  #
  class Matrix

    # Different Enviroments register here. (TODO Helper method)
    ENVIRNOMENTS = {}

    def initialize(enviroment)
      @enviroment = ENVIRNOMENTS[enviroment].new(self)
      @clients = {}
      @state = :waiting
    end

    # @return [Hash<Object, Client>] clients Hash containing all clients
    #   associated to this matrix
    attr_reader :clients

    # @return [Symbol] state the state of the matrix
    attr_reader :state

    # @return [Enviroment] enviroment the enviroment the matrix is running in
    attr_reader :enviroment

    # @param [Hash] hash
    # @option hash [Object] 'id' id of the Client
    # @option hash [String] 'lang' language used
    # @option hash [Array<String>] 'libs' libraries to load WARNING! sanitize them!
    # @option hash [String] 'code' code to load
    # @return [Client] the new client
    def add_client(hash)
      raise "Matrix running, you can't add new clients!" unless @state == :waiting
      clients[id] = Client.new(hash, self)
    end

    # Let the fun begin!
    def enter_the_matrix
      @state = :starting
      # probably add timer here
      enter
    end

    # callback method from the clients
    def enter
      if @state == :starting and clients.values.all? { |client| client.ready }
        enviroment.enter_the_matrix
      end
    end

    # @param [Hash] send a hash to all clients
    def broadcast(hash)
      clients.each { |ident, client| client.send_hash(hash) }
    end

  end
end
