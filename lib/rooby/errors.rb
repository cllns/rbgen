# frozen_string_literal: true

module Rooby
  class Error < StandardError; end

  class InvalidInstanceVariablesError < Error
    def initialize
      super("Instance variables must start with an @ symbol")
    end
  end

  class DuplicateInitializeMethodError < Error
    def initialize
      super("Initialize method cannot be defined if instance variables are present")
    end
  end

  class GeneratedUnparseableCodeError < Error
    def initialize(source_code)
      super(
        <<~ERROR_MESSAGE
          Sorry, the code we generated is not valid Ruby.

          Here's what we got:

          #{source_code}

          Please fix the errors and try again.
        ERROR_MESSAGE
      )
    end
  end
end
