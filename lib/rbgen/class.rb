# frozen_string_literal: true

require "prism"

module RbGen
  class Class
    INDENT = "  "

    # rubocop:disable Metrics/ParameterLists
    def initialize(
      name,
      parent = nil,
      modules: [],
      requires: [],
      relative_requires: [],
      methods: {},
      includes: [],
      ivars: []
    )
      @name = name
      @parent = parent
      @modules = modules
      @requires = requires
      @relative_requires = relative_requires
      @methods = methods
      @includes = includes
      @ivar_names = parse_ivar_names!(ivars)

      raise DuplicateInitializeMethodError if methods.key?(:initialize) && ivars.any?
    end
    # rubocop:enable Metrics/ParameterLists

    def to_s
      definition = lines(modules).map { |line| "#{line}\n" }.join

      source_code = [file_directives, definition].flatten.join("\n")

      ensure_parseable!(source_code)
    end

    private

    attr_reader :name, :parent, :modules, :requires, :relative_requires, :methods, :includes, :ivar_names

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

    def file_directives
      [frozen_string_literal, import_lines].compact
    end

    def frozen_string_literal
      if RbGen.config.frozen_string_literal
        ["# frozen_string_literal: true", ""].join("\n")
      end
    end

    def import_lines
      lines = [requires_lines, relative_requires_lines].flatten.compact
      if lines.any?
        lines << ""
      end
    end

    def requires_lines
      requires.map do |require|
        %(require "#{require}")
      end
    end

    def relative_requires_lines
      relative_requires.map do |require|
        %(require_relative "#{require}")
      end
    end

    def class_lines
      [
        class_definition,
        *includes_lines,
        *class_contents_lines,
        "end"
      ].compact
    end

    def includes_lines
      includes.map do |include|
        indent(%(include #{include}))
      end
    end

    def class_contents_lines
      [
        initialize_lines,
        methods_lines,
        private_contents_lines
      ].compact.flatten.map { |line| indent(line) }
    end

    def initialize_lines
      if ivar_names.any?
        [
          method_definition("initialize", ivar_names.map { |ivar| "#{ivar}:" }),
          ivar_names.map { |ivar_name| indent("@#{ivar_name} = #{ivar_name}") }.flatten,
          "end",
          ""
        ]
      end
    end

    def private_contents_lines
      if ivar_names.any?
        [
          " ",
          "private",
          "",
          "attr_reader #{ivar_names.map { |ivar| ":#{ivar}" }.join(', ')}"
        ]
      end
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

    def parse_ivar_names!(ivars)
      if ivars.all? { |ivar| ivar.start_with?("@") }
        ivars.map { |ivar| ivar.to_s.delete_prefix("@") }
      else
        raise InvalidInstanceVariablesError
      end
    end

    def ensure_parseable!(source_code)
      parse_result = Prism.parse(source_code)

      if parse_result.success?
        source_code
      else
        raise GeneratedUnparseableCodeError.new(source_code)
      end
    end
  end
end
