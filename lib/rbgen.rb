# frozen_string_literal: true

require "dry-configurable"
require_relative "rbgen/version"
require_relative "rbgen/class"
require_relative "rbgen/errors"

module RbGen
  extend Dry::Configurable

  setting :frozen_string_literal, default: true
end
