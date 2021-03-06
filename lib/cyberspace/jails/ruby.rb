module Cyberspace
  module Jails
    class Ruby

      # @param [Array<String>] libs libraries to load
      # @param [String] code code to run
      # @param [Class, Module] server passed to EM::popen
      def initialize(libs, code, server)
        @libs, @code, @server = libs, code, server
        @libs.unshift('cyberspace/json_protocol')
        enter_the_matrix
      end

      # @return [EM::Connection] connection The EM connection
      attr_reader :connection

      # connect the client, and let it send back {:action => ready} when
      # all code is loaded, so the game can start
      def enter_the_matrix
        # TODO what if it fails?
        self.connection = EM::popen("ruby #{@libs.map {|lib| "-r'#{lib}' "}} -T3", @server)
        connection.send_data(@code)
        connection.send_data <<-CODE
          __END__
        CODE
      end

    end
  end
end
