# frozen_string_literal: true

RSpec.describe Rooby::Class do
  describe "top-level" do
    it "generates class without parent class" do
      expect(Rooby::Class.new("Greeter").to_s).to eq(
        <<~OUTPUT
          class Greeter
          end
        OUTPUT
      )
    end

    it "generates class with parent class" do
      expect(Rooby::Class.new("Greeter", "BaseService").to_s).to eq(
        <<~OUTPUT
          class Greeter < BaseService
          end
        OUTPUT
      )
    end
  end
end
