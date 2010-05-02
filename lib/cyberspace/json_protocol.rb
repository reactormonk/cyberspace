require 'json'
module Cyberspace

  # The Protocol is basically JSON hashes separated by zero bytes.
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
          send_hash({:status => :error, :data => {:error => e.class, :body => e, :backtrace => e.backtrace, :sent => json}})
        end
      end
    end

    attr :receiver

    # @raise [NoMethodError] in case the specified action isn't defined
    # @return [Object] the return value of the called action
    def receive_hash(hash)
      if (receiver ||= self).respond_to?(hash['action']) && ! Object.method_defined?(hash['action'])
        receiver.send(hash['action'])
      else
        raise NoMethodError, "private method called: #{hash['action']}"
      end
    end

    # @param [#to_json]
    # @see EventMachine::Connection#send_data
    def send_hash(hash)
      send_data(hash.to_json + "\x00")
    end

  end
end
