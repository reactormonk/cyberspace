require 'json'
module Cyberspace
  # JSON Data is received as following:
  #
  # action  => <method name>
  # data    => <parameters>
  #
  # JSON Data is sent as following:
  #
  # status => <error, ok>
  # data   => ...
  #
  # If an exception occured, the data will be sent as:
  # error     => e.class
  # body      => e
  # backtrace => e.backtrace
  # sent      => json         # incoming data
  #
  module JSONProtocol

    private

    def receive_data(data)
      (@buffer ||= BufferedTokenizer.new("\x00")).extract(data).each do |json|
        begin
          receive_hash(JSON.parse(json))
        rescue => e
          send_hash({:status => :error, :data => {:error => e.class, :body => e, :backtrace => e.backtrace, :sent => json}})
        end
      end
    end

    attr :receiver

    def receive_hash(hash)
      if (receiver ||= self).respond_to?(hash['action']) && ! Object.new.respond_to?(hash['action'])
        receiver.send(hash['action'])
      else
        raise NoMethodError, "private method called: #{hash['action']}"
      end
    end

    def send_hash(hash)
      send_data(hash.to_json + "\x00")
    end

  end
end
