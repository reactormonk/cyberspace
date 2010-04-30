module CyberSpace
  module JSONProtocol
    def receive_data(data)
      (@buffer ||= BufferedTokenizer.new("\x00").extract(data).each do |json|
        receive_json(json)
      end
    end
  end
end
