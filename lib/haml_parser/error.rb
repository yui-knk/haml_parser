# frozen-string-literal: true
module HamlParser
  class Error < StandardError
    attr_accessor :lineno

    def initialize(message, lineno)
      @lineno = lineno
      super("#{message} Line: #{lineno}")
    end
  end
end
