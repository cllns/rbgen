# frozen_string_literal: true

module Rooby
  class Class
    INDENT = "  "

    def initialize(name, parent = nil, modules: [], methods: {})
      @name = name
      @parent = parent
      @modules = modules
      @methods = methods
    end

    def to_s
      definition = lines(modules).map { |line| "#{line}\n" }.join

      if Rooby.config.frozen_string_literal
        ["# frozen_string_literal: true", "", definition].join("\n")
      else
        definition
      end
    end

    private

    attr_reader :name, :parent, :modules, :methods

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
        *contents_lines.map { |line| indent(line) },
        "end"
      ]
    end

    def class_lines
      [
        class_definition,
        *class_contents_lines,
        "end"
      ].compact
    end

    def class_contents_lines
      methods_lines.map { |line| indent(line) }
    end

    def methods_lines
      # To add a newline between each method, we add an empty string to the end
      # of each method definition then remove the very last one
      methods.flat_map do |method_name, args|
        [method_definition(method_name, args), "end", ""]
      end[0...-1]
    end

    def class_definition
      if parent
        "class #{name} < #{parent}"
      else
        "class #{name}"
      end
    end

    def method_definition(method_name, args)
      if args
        "def #{method_name}(#{args.join(', ')})"
      else
        "def #{method_name}"
      end
    end

    def indent(line)
      if line.strip.empty?
        ""
      else
        INDENT + line
      end
    end
  end
end
