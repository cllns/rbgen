# frozen_string_literal

module Rooby
  class Class
    def initialize(name, parent = nil)
      @name = name
      @parent = parent
    end

    def to_s
      if parent
        <<~OUTPUT
          class #{@name} < #{@parent}
          end
        OUTPUT
      else
        <<~OUTPUT
          class #{@name}
          end
        OUTPUT
      end
    end

    private

    attr_reader :name, :parent
  end
end
