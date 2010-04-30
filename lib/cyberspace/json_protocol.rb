require 'json'
module CyberSpace
  module JSONProtocol
    def receive_data(data)
      (@buffer ||= BufferedTokenizer.new("\x00").extract(data).each do |json|
        receive_hash(JSON.parse(json))
      end
    end

    def send_hash(hash)
      send_data(hash.to_json + "\x00")
    end

  end
end
