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
end
