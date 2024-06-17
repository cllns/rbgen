# frozen_string_literal: true

RSpec.describe Rooby::Class do
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

  describe "with multiple modules" do
    it "generates class without parent class" do
      expect(Rooby::Class.new("Greeter", modules: %w[Admin Services]).to_s).to(
        eq(
          <<~OUTPUT
            module Admin::Services
              class Greeter
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
            module Admin::Services
              class Greeter < BaseService
              end
            end
          OUTPUT
        )
      )
    end
  end
end
