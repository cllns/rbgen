# RbGen

RbGen is a Ruby file generator.

## Installation

Add the following line to your `Gemfile`:

```bash
gem "rbgen"
```

## Usage

### Simple example:
```ruby
puts RbGen::Class.new("Greeter", "BaseService").to_s
```

Outputs:

```ruby
# frozen_string_literal: true

#  class Greeter < BaseService
#  end
```

### Nested modules example
```ruby
puts RbGen::Class.new("Greeter", "BaseService", modules: ["Admin", "Services"]).to_s
```

Outputs:

```
# frozen_string_literal: true

module Admin
  module Services
    class Greeter < Base
    end
  end
end
```


### Full example
```ruby
puts RbGen::Class.new(
    "Greeter",
    "Base",
    modules: ["Admin", "Services"],
    requires: ["prism"],
    relative_requires: ["secret/parser"],
    methods: {call: ["params", "options:"]},
    ivars: [:@name, :@birthday],
).to_s
```

```ruby
# frozen_string_literal: true

require "prism"
require_relative "secret/parser"

module Admin
  module Services
    class Greeter < Base
      def initialize(name:, birthday:)
        @name = name
        @birthday = birthday
      end

      def call(params, options:)
      end

      private

      attr_reader :name, :birthday
    end
  end
end
```


Caveats:
- You can define your own empty `initialize` method with `methods:` but not if you use `ivars:`
- `ivars:` must begin with `@`
- We currently don't do *any* inflections, so you must write the strings in the proper format.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/cllns/rbgen. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/rbgen/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the RbGen project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/cllns/rbgen/blob/main/CODE_OF_CONDUCT.md).
