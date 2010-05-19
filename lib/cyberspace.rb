require 'cyberspace/master'
require 'eventmachine'

module Cyberspace
  # Start the Master. Uses EM::run, therefore call this method last.
  # @param [String] host Server, either IP or UNIX socket path
  # @param [Integer] port if TCP server, enter port here
  def self.enter_the_matrix(host, port=nil)
    EM::run do
      self.connection = EM::start_server(host, port, Cyberspace::Master)
    end
  end

  class << self
    # @return [EM::Connection] master connection
    attr :connection
  end
end
