# frozen_string_literal: true

RSpec.describe Rooby::Class do
  it "generates basic class" do
    expect(Rooby::Class.new("Greeter").to_s).to eq(
      <<~OUTPUT
        class Greeter
        end
      OUTPUT
    )
  end
end
