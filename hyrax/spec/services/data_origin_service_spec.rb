require 'rails_helper'

RSpec.describe DataOriginService do
  let(:service) { described_class.new }

  describe "#select_active_options" do
    it "returns active terms" do
      expect(service.select_active_options).to include(
        ["experiments/実験", "experiments/実験"],
        ["informatics and data science/情報・データ科学", "informatics and data science/情報・データ科学"])
    end
  end
end
