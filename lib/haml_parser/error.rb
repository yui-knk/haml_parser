# frozen-string-literal: true
module HamlParser
  class Error < StandardError
    attr_accessor :lineno

    def initialize(message, lineno)
      super(message)
      @lineno = lineno
    end
  end
end
