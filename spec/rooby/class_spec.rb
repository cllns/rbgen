# frozen_string_literal: true

RSpec.describe Rooby::Class do
  describe "without frozen_string_literal" do
    before do
      Rooby.config.frozen_string_literal = false
    end

    describe "top-level" do
      it "generates class without parent class" do
        expect(Rooby::Class.new("Greeter").to_s).to(
          eq(
            <<~OUTPUT
              class Greeter
              end
            OUTPUT
          )
        )
      end

      it "generates class with parent class" do
        expect(Rooby::Class.new("Greeter", "BaseService").to_s).to(
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
        expect(Rooby::Class.new("Greeter", modules: %w[Services]).to_s).to(
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
        expect(Rooby::Class.new("Greeter", "BaseService", modules: %w[Services]).to_s).to(
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
        expect(Rooby::Class.new("Greeter", modules: %w[Admin Services]).to_s).to(
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
        expect(Rooby::Class.new("Greeter", "BaseService", modules: %w[Admin Services]).to_s).to(
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
        expect(Rooby::Class.new("Greeter", modules: %w[Internal Admin Services]).to_s).to(
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
        expect(Rooby::Class.new("Greeter", "BaseService", modules: %w[Internal Admin Services]).to_s).to(
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
      Rooby.reset_config
    end

    describe "top-level" do
      it "generates class without parent class" do
        expect(Rooby::Class.new("Greeter").to_s).to(
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
        expect(Rooby::Class.new("Greeter", "BaseService").to_s).to(
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
