require_relative 'json_protocol'
require_relative 'matrix/server'
require_relative 'matrix/client'
require 'state_machine'

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

    state_machine(initial: :loading) do

      event :ready do
        transition :loading => :ready
      end

      before_transition to: :ready do |matrix, transition|
        throw :halt unless matrix.clients.all? { |ident, client| client.ready? }
      end

      event :loading do
        transition :ready => :loading
      end

    end

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
      loading
      clients[identifier] = Client.new(identifier, lang, libs, code, self)
    end

    # @param [Hash] send a hash to all clients
    def broadcast(hash)
      clients.each { |ident, client| client.send_hash(hash) }
    end

  end
end
