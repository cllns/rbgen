# frozen_string_literal: true

# frozen_string_literal

module Rooby
  class Class
    def initialize(name, parent = nil)
      @name = name
      @parent = parent
    end

    def to_s
      if parent
        with_parent
      else
        without_parent
      end
    end

    private

    attr_reader :name, :parent

    def with_parent
      <<~OUTPUT
        class #{@name} < #{@parent}
        end
      OUTPUT
    end

    def without_parent
      <<~OUTPUT
        class #{@name}
        end
      OUTPUT
    end
  end
end
