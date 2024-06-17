# frozen_string_literal: true

module Rooby
  class Class
    INDENT = "  "

    def initialize(name, parent = nil, modules: [])
      @name = name
      @parent = parent
      @modules = modules
    end

    def to_s
      lines(modules).map { |line| "#{line}\n" }.join
    end

    private

    attr_reader :name, :parent, :modules

    def lines(remaining_modules)
      this_module, *rest_modules = remaining_modules
      if this_module
        with_module_lines(this_module, lines(rest_modules))
      else
        class_lines
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
