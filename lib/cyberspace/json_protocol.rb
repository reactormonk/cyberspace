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
          send_hash(action: hash['action'], data: receive_hash(JSON.parse(json)))
        rescue => e
          send_hash({:action => :error, :data => {:error => e.class, :body => e, :backtrace => e.backtrace, :sent => json}})
        end
      end
    end

    # @return [Object] (self) The object that should receive the actions.
    def receiver
      @receiver ||= self
    end

    # @param [Object] The object that should receive the actions.
    attr_writer :receiver

    # Calls the method specified.
    # @option hash [String] 'action' method to be called
    # @option hash [Hash] 'data' parameters
    # @raise [NoMethodError] in case the specified action is invalid.
    #   An action is invalid, if /^__.*/ or /=/ or the object doesn't respond
    #   to that action.
    # @raise [ArgumentError] if the arity of the action called is wrong.
    # @return [Object] the return value of the called action
    def receive_hash(hash)
      action = hash['action']
      if action !~ /^__.*/ && action !~ /=/ && receiver.respond_to?(action)
        case receiver.method(action).arity
        when 0
          receiver.send(action)
        when 1, -1, -2
          receiver.send(action, hash['data'])
        else
          raise ArgumentError, "#{action} got incorrect arity"
        end
      else
        raise NoMethodError, "action not allowed: #{action}"
      end
    end

    # @param [#to_json] hash hash to be sent to the agent
    # @see EventMachine::Connection#send_data
    # @return [void]
    def send_hash(hash)
      send_data(hash.to_json + "\x00")
    end

    protected

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
