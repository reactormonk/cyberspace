module Cyberspace
  module Master
    include JSONProtocol

    # @return [Hash<String, Matrix>] all avaible matrixes
    class << self
      attr_reader :matrixes
    end

    # @param [Hash] hash create a new Matrix
    # @option hash [String] 'env' which enviroment (in Matrix::ENVIRNOMENTS)
    # @option hash [String] 'id' a hash key for the Matrix
    def new_matrix(hash)
      check_existence(hash, %w(env id))
      raise ArgumentError, "id taken" if self.class.matrixes[hash['id']]
      self.class.matrixes[hash['id']] = Matrix.new(hash['env'])
      hash['id'] # for the JSONProtocol
    end

    # @param [Hash] hash data for the new agent
    # @option hash [String] 'id' id for the agent
    # @option hash [String] 'matrix_id' (self.class.matrixes.values.last)
    #   which matrix the agent belongs to
    # @option hash [String] 'lang' which language the agent is written in
    # @option hash [Array] 'libs' ([]) which libraries to require
    # @option hash [String] 'code' code to execute
    # @raise [RuntimeException] see messages ;-)
    def new_agent(hash)
      check_existence(hash, %w(id lang code))
      if matrix_id = hash['matrix_id']
        unless matrix = self.class.matrixes[matrix_id]
          raise "Matrix with id #{matrix_id} not found."
        end
      else
        unless matrix = self.class.matrixes.values.last
          raise "No Matrix initialized yet."
        end
      end
      matrix.add_client(hash)
      hash['id']
    end

  end
end
