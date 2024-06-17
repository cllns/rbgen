# frozen_string_literal: true

# frozen_string_literal

module Rooby
  class Class
    def initialize(name, parent = nil, modules: [])
      @name = name
      @parent = parent
      @modules = modules
    end

    def to_s
      if modules.any?
        with_modules
      else
        without_modules
      end
    end

    private

    attr_reader :name, :parent, :modules

    def without_modules
      if parent
        with_parent_and_without_modules
      else
        without_parent_and_without_modules
      end
    end

    def with_parent_and_without_modules
      <<~OUTPUT
        class #{name} < #{parent}
        end
      OUTPUT
    end

    def without_parent_and_without_modules
      <<~OUTPUT
        class #{name}
        end
      OUTPUT
    end

    def with_modules
      if parent
        with_parent_and_with_modules
      else
        without_parent_and_with_modules
      end
    end

    def with_parent_and_with_modules
      <<~OUTPUT
        module #{modules.join('::')}
          class #{name} < #{parent}
          end
        end
      OUTPUT
    end

    def without_parent_and_with_modules
      <<~OUTPUT
        module #{modules.join('::')}
          class #{name}
          end
        end
      OUTPUT
    end
  end
end
