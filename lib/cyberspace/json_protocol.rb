require 'json'
require 'eventmachine'

module Cyberspace

  # The Protocol is basically JSON hashes separated by zero bytes.
  #
  # Basic Parameters (may be added to each request):
  #
  # wait (True or False):
  #   determines wherever to wait if not enough AP are avaible or send
  #   an error message back
  #
  module JSONProtocol

    private

    # @see EventMachine::Connection#receive_data
    # EM sends incoming data to this method, it's being parsed and rescued
    # here. The method passes the parsed hash to {#receive_hash}, rescing to
    #
    # error     => e.class
    # body      => e
    # backtrace => e.backtrace
    # sent      => json         # data that caused the error
    #
    def receive_data(data)
      (@buffer ||= BufferedTokenizer.new("\x00")).extract(data).each do |json|
        begin
          send_hash(receive_hash(JSON.parse(json)))
        rescue => e
          send_hash({:action => :error, :data => {:error => e.class, :body => e, :backtrace => e.backtrace, :sent => json}})
        end
      end
    end

    attr :receiver

    # @raise [NoMethodError] in case the specified action isn't defined
    # @return [Object] the return value of the called action
    # @param [Hash] hash JSON hash passed
    # @option hash [String] 'action' method to be called
    # @option hash [Hash] 'data' parameters
    def receive_hash(hash)
      if hash['action'] !~ /^__.*/ && (receiver ||= self).respond_to?(hash['action'])
        case receiver.method(hash['action']).arity
        when 0
          receiver.send(hash['action'])
        when 1, -1, -2
          receiver.send(hash['action'], hash['data'])
        else
          raise ArgumentError, "#{hash['action']} got incorrect arity"
        end
      else
        raise NoMethodError, "action not allowed: #{hash['action']}"
      end
    end

    # @param [#to_json] hash hash to be sent to the agent
    # @see EventMachine::Connection#send_data
    def send_hash(hash)
      send_data(hash.to_json + "\x00")
    end

    # @param [Hash] hash to be checked
    # @param [Array<String>] *keys to check for
    # @raise [ArgumentError] if the key doesn't exist
    def check_existence(hash, *keys)
      keys.each do |key|
        raise ArgumentError, "no #{key} given" unless hash.has_key?(key)
      end
    end

  end
end
