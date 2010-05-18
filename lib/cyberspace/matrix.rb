require_relative 'json_protocol'
require_relative 'matrix/server'
require_relative 'matrix/client'

module Cyberspace

  # @param [Class] matrix the matrix you want to register
  # @param [#to_s] name (matrix) how you want to call it
  def self.register(matrix, name=matrix)
    Matrix::ENVIRNOMENTS.merge!(name.to_s => matrix)
  end

  class Matrix

    ENVIRNOMENTS = {}

    # @param [String] enviroment where the matrix should run
    def initialize(enviroment)
      raise "enviroment not registered" unless env = ENVIRNOMENTS[enviroment]
      @enviroment = env.new(self)
      @clients = {}
      @state = :waiting
    end

    # @return [Hash<Object, Client>] Hash containing all clients
    #   associated to this matrix
    attr_reader :clients

    # @return [Symbol] the state of the matrix
    attr_reader :state

    # @return [Enviroment] the enviroment the matrix is running in
    attr_reader :enviroment

    # Add a client to the Matrix specified with 'id'
    # @option params [Object] 'id' id of the Client
    # @option params [String] 'lang' language used
    # @option params [Array<String>] 'libs' libraries to load WARNING! sanitize them!
    # @option params [String] 'code' code to load
    # @return [Client] the new client
    def add_client(params)
      raise "Matrix not waiting, you can't add new clients!" unless @state == :waiting
      clients[id] = Client.new(params, self)
    end

    # @param [Object] client the Client to remove
    # @return [Object] client id
    def remove_client(client)
      clients.delete(client)
    end

    # Let the fun begin!
    # @return [void]
    def enter_the_matrix
      @state = :starting
      # probably add timer here
      enter
    end

    # callback method from the clients
    # @return [void]
    def enter
      if @state == :starting and clients.values.all? { |client| client.ready }
        enviroment.enter_the_matrix
      end
    end

    # @param [Hash] hash send a hash to all clients
    # @return [void]
    def broadcast(hash)
      clients.each { |ident, client| client.send(:send_hash,hash) }
    end

  end
end
