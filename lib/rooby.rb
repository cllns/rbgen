# frozen_string_literal: true

require "dry-configurable"

require_relative "rooby/version"
require_relative "rooby/class"

module Rooby
  extend Dry::Configurable

  setting :frozen_string_literal, default: true
end
