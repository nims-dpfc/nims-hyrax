require 'rails_helper'

RSpec.describe SynthesisAndProcessingService do
  let(:service) { described_class.new }

  describe "#select_active_options" do
    it "returns active terms" do
      expect(service.select_active_options).to include(
        ["casting/鋳造", "casting"],
        [
          "annealing and homogenization/アニーリング_均一化処理 -- mechanical mixing/機械的混合",
          "annealing and homogenization -- mechanical mixing"
        ])
    end
  end
end
