module Cyberspace
  module Jails
    class Ruby

      # @param [Array<String>] libraries to load
      # @param [String] code to run
      # @param [Class, Module] passed to EM::popen
      def initialize(libs, code, server)
        @libs, @code, @server = libs, code, server
        @libs.unshift('json')
        enter_the_matrix
      end

      # The EM connection
      attr_reader :connection

      # connect the client, and let it send back {:load => :finished} when
      # all code is loaded, so the game can start
      def enter_the_matrix
        self.connection = EM::popen("ruby #{@libs.map {|lib| "-r#{lib} "}} -T3", @server)
        connection.send_data(@code)
        connection.send_data <<-CODE
          puts {:action => ready}.to_json + "\x00"
          __END__
        CODE
      end

    end
  end
end
