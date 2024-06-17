# frozen_string_literal

module Rooby
  class Class
    def initialize(name)
      @name = name
    end

    def to_s
      <<~OUTPUT
        class #{@name}
        end
      OUTPUT
    end
  end
end
