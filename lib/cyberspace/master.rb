module Cyberspace
  module Master
    include JSONProtocol

    class << self
      # @return [Hash<String, Matrix>] all avaible matrixes
      attr_reader :matrixes
    end

    # Create a new Matrix
    # @option params [String] 'env' which enviroment (in Matrix::ENVIRNOMENTS)
    # @option params [Object] 'id' a hash key for the Matrix (likely a String)
    # @return [Object] the id of the created matrix
    def new_matrix(params={})
      check_existence(params, %w(env id))
      raise ArgumentError, "id taken" if self.class.matrixes[params['id']]
      self.class.matrixes[params['id']] = Matrix.new(params['env'])
      params['id'] # for the JSONProtocol
    end

    # Create a new Agent
    # @option params [String] 'id' id for the agent
    # @option params [String] 'matrix_id' (self.class.matrixes.values.last)
    #   which matrix the agent belongs to
    # @option params [String] 'lang' which language the agent is written in
    # @option params [Array] 'libs' ([]) which libraries to require
    # @option params [String] 'code' code to execute
    # @raise [RuntimeException] see messages ;-)
    # @return [Object] the id of the created Agent
    def new_agent(params={})
      # TODO better error inheritance
      check_existence(params, %w(id lang code))
      if matrix_id = params['matrix_id']
        unless matrix = self.class.matrixes[matrix_id]
          raise "Matrix with id #{matrix_id} not found."
        end
      else
        unless matrix = self.class.matrixes.values.last
          raise "No Matrix initialized yet."
        end
      end
      matrix.add_client(params)
      params['id']
    end

  end
end
