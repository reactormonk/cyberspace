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

    def initialize
      @clients = {}
      @state = :waiting
    end

    attr :clients

    # @param [Object] identifier of the Client
    # @param [String] language used
    # @param [Array<String>] libraries to load WARNING! sanitize them!
    # @param [String] code to load
    def add_client(identifier, lang, libs, code)
      clients[identifier] = Client.new(identifier, lang, libs, code, self)
    end

    # @param [Hash] send a hash to all clients
    def broadcast(hash)
      clients.each { |ident, client| client.send_hash(hash) }
    end

  end
end
