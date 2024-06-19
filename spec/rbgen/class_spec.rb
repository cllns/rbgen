# frozen_string_literal: true

RSpec.describe RbGen::Class do
  describe "no methods" do
    describe "without frozen_string_literal" do
      before do
        RbGen.config.frozen_string_literal = false
      end

      describe "top-level" do
        it "generates class without parent class" do
          expect(RbGen::Class.new("Greeter").to_s).to(
            eq(
              <<~OUTPUT
                class Greeter
                end
              OUTPUT
            )
          )
        end

        it "generates class with parent class" do
          expect(RbGen::Class.new("Greeter", "BaseService").to_s).to(
            eq(
              <<~OUTPUT
                class Greeter < BaseService
                end
              OUTPUT
            )
          )
        end
      end

      describe "with single module" do
        it "generates class without parent class" do
          expect(RbGen::Class.new("Greeter", modules: %w[Services]).to_s).to(
            eq(
              <<~OUTPUT
                module Services
                  class Greeter
                  end
                end
              OUTPUT
            )
          )
        end

        it "generates class with parent class" do
          expect(RbGen::Class.new("Greeter", "BaseService", modules: %w[Services]).to_s).to(
            eq(
              <<~OUTPUT
                module Services
                  class Greeter < BaseService
                  end
                end
              OUTPUT
            )
          )
        end
      end

      describe "with two modules" do
        it "generates class without parent class" do
          expect(RbGen::Class.new("Greeter", modules: %w[Admin Services]).to_s).to(
            eq(
              <<~OUTPUT
                module Admin
                  module Services
                    class Greeter
                    end
                  end
                end
              OUTPUT
            )
          )
        end

        it "generates class with parent class" do
          expect(RbGen::Class.new("Greeter", "BaseService", modules: %w[Admin Services]).to_s).to(
            eq(
              <<~OUTPUT
                module Admin
                  module Services
                    class Greeter < BaseService
                    end
                  end
                end
              OUTPUT
            )
          )
        end
      end

      describe "with three modules" do
        it "generates class without parent class" do
          expect(RbGen::Class.new("Greeter", modules: %w[Internal Admin Services]).to_s).to(
            eq(
              <<~OUTPUT
                module Internal
                  module Admin
                    module Services
                      class Greeter
                      end
                    end
                  end
                end
              OUTPUT
            )
          )
        end

        it "generates class with parent class" do
          expect(RbGen::Class.new("Greeter", "BaseService", modules: %w[Internal Admin Services]).to_s).to(
            eq(
              <<~OUTPUT
                module Internal
                  module Admin
                    module Services
                      class Greeter < BaseService
                      end
                    end
                  end
                end
              OUTPUT
            )
          )
        end
      end
    end

    describe "with frozen_string_literal (default)" do
      before do
        RbGen.reset_config
      end

      describe "top-level" do
        it "generates class without parent class" do
          expect(RbGen::Class.new("Greeter").to_s).to(
            eq(
              <<~OUTPUT
                # frozen_string_literal: true

                class Greeter
                end
              OUTPUT
            )
          )
        end

        it "generates class with parent class" do
          expect(RbGen::Class.new("Greeter", "BaseService").to_s).to(
            eq(
              <<~OUTPUT
                # frozen_string_literal: true

                class Greeter < BaseService
                end
              OUTPUT
            )
          )
        end
      end
    end
  end

  describe "with methods" do
    describe "without frozen_string_literal" do
      before do
        RbGen.config.frozen_string_literal = false
      end

      describe "top-level" do
        it "generates class without parent class and call method with no args" do
          expect(RbGen::Class.new("Greeter", methods: {call: nil}).to_s).to(
            eq(
              <<~OUTPUT
                class Greeter
                  def call
                  end
                end
              OUTPUT
            )
          )
        end

        it "generates class with parent class and call method with 1 arg" do
          expect(RbGen::Class.new("Greeter", "BaseService", methods: {call: ["args"]}).to_s).to(
            eq(
              <<~OUTPUT
                class Greeter < BaseService
                  def call(args)
                  end
                end
              OUTPUT
            )
          )
        end
      end

      describe "with single module" do
        it "generates class without parent class and call methods with 2 args" do
          expect(RbGen::Class.new("Greeter", modules: %w[Services], methods: {call: %w[request response]}).to_s).to(
            eq(
              <<~OUTPUT
                module Services
                  class Greeter
                    def call(request, response)
                    end
                  end
                end
              OUTPUT
            )
          )
        end

        it "generates class with parent class and call method with required keyword args" do
          expect(RbGen::Class.new("Greeter", "BaseService", modules: %w[Services], methods: {call: %w[request: response:]}).to_s).to(
            eq(
              <<~OUTPUT
                module Services
                  class Greeter < BaseService
                    def call(request:, response:)
                    end
                  end
                end
              OUTPUT
            )
          )
        end
      end

      describe "with two modules" do
        it "generates class without parent class and call method with mix of args" do
          expect(
            RbGen::Class.new(
              "Greeter",
              modules: %w[Admin Services],
              methods: {call: ["env", "request:", "response:", "context: nil"]}
            ).to_s
          ).to(
            eq(
              <<~OUTPUT
                module Admin
                  module Services
                    class Greeter
                      def call(env, request:, response:, context: nil)
                      end
                    end
                  end
                end
              OUTPUT
            )
          )
        end

        it "generates class with parent class and two methods" do
          expect(RbGen::Class.new(
            "Greeter",
            "BaseService",
            modules: %w[Admin Services],
            methods: {initialize: ["context"], call: ["args"]}
          ).to_s).to(
            eq(
              <<~OUTPUT
                module Admin
                  module Services
                    class Greeter < BaseService
                      def initialize(context)
                      end

                      def call(args)
                      end
                    end
                  end
                end
              OUTPUT
            )
          )
        end
      end

      describe "with three modules" do
        it "generates class without parent class, with ivars and method" do
          expect(
            RbGen::Class.new(
              "Greeter",
              modules: %w[Internal Admin Services],
              ivars: [:@name, :@birthdate],
              methods: {call: [:env]}
            ).to_s
          ).to(
            eq(
              <<~OUTPUT
                module Internal
                  module Admin
                    module Services
                      class Greeter
                        def initialize(name:, birthdate:)
                          @name = name
                          @birthdate = birthdate
                        end

                        def call(env)
                        end

                        private

                        attr_reader :name, :birthdate
                      end
                    end
                  end
                end
              OUTPUT
            )
          )
        end

        it "raises error when ivars don't lead with @" do
          expect {
            RbGen::Class.new(
              "Greeter",
              ivars: [:name]
            ).to_s
          }.to(raise_error(RbGen::InvalidInstanceVariablesError))
        end

        it "raises error when 'initialize' method is specified and ivars are present" do
          expect {
            RbGen::Class.new(
              "Greeter",
              ivars: [:@name],
              methods: {initialize: nil}
            ).to_s
          }.to(raise_error(RbGen::DuplicateInitializeMethodError))
        end

        it "generates class with parent class, and requires" do
          expect(RbGen::Class.new(
            "Greeter",
            "BaseService",
            modules: %w[Internal Admin Services],
            requires: ["roobi/fake"]
          ).to_s).to(
            eq(
              <<~OUTPUT
                require "roobi/fake"

                module Internal
                  module Admin
                    module Services
                      class Greeter < BaseService
                      end
                    end
                  end
                end
              OUTPUT
            )
          )
        end
      end
    end

    describe "with includes" do
      it "generates class with includes" do
        expect(RbGen::Class.new(
          "Greeter",
          includes: ["Enumerable", %(Import["external.api"])]
        ).to_s).to(
          eq(
            <<~OUTPUT
              class Greeter
                include Enumerable
                include Import["external.api"]
              end
            OUTPUT
          )
        )
      end
    end

    describe "with frozen_string_literal (default)" do
      before do
        RbGen.reset_config
      end

      describe "top-level" do
        it "generates class without parent class and both requires and relative_requires" do
          expect(RbGen::Class.new(
            "Greeter",
            requires: ["roobi/fake"],
            relative_requires: ["secret/parser"]
          ).to_s).to(
            eq(
              <<~OUTPUT
                # frozen_string_literal: true

                require "roobi/fake"
                require_relative "secret/parser"

                class Greeter
                end
              OUTPUT
            )
          )
        end

        it "fails to generate unparseable ruby code" do
          expect { RbGen::Class.new("%%Greeter").to_s }.to(
            raise_error(RbGen::GeneratedUnparseableCodeError)
          )
        end
      end
    end
  end
end
