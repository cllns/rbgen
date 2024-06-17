# frozen_string_literal: true

require "dry-configurable"
require_relative "rooby/version"
require_relative "rooby/class"
require_relative "rooby/errors"

module Rooby
  extend Dry::Configurable

  setting :frozen_string_literal, default: true
end
