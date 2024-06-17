# frozen_string_literal: true

# frozen_string_literal

module Rooby
  class Class
    INDENT = "  "

    def initialize(name, parent = nil, modules: [])
      @name = name
      @parent = parent
      @modules = modules
    end

    def to_s
      lines = if modules.any?
                with_modules_lines
              else
                class_lines
              end

      lines.map { |line| "#{line}\n" }.join
    end

    private

    attr_reader :name, :parent, :modules

    def with_modules_lines
      if modules.size == 1
        with_module_lines(modules[0], class_lines)
      elsif modules.size == 2
        with_module_lines(modules[0], with_module_lines(modules[1], class_lines))
      end
    end

    def with_module_lines(module_name, contents_lines)
      [
        "module #{module_name}",
        *contents_lines.map { |line| INDENT + line },
        "end"
      ]
    end

    def class_lines
      [
        class_definition,
        "end"
      ]
    end

    def class_definition
      if parent
        "class #{name} < #{parent}"
      else
        "class #{name}"
      end
    end
  end
end
