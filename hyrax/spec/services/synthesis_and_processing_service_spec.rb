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

  describe "find_by_id" do
    it "returns active term matching id" do
      expect(service.find_by_id('casting')).to include({
        "label" => "casting/鋳造",
        "id" => "casting",
        "active" => true
      })
    end
  end

  describe "find_by_label" do
    it "returns active term  matching label" do
      expect(service.find_by_label('casting/鋳造')).to include({
        "label" => "casting/鋳造",
        "id" => "casting",
        "active" => true
      })
    end
  end

  describe "find_by_id_or_label" do
    it "returns active term matching id or label" do
      expect(service.find_by_id_or_label('casting')).to include({
        "label" => "casting/鋳造",
        "id" => "casting",
        "active" => true
      })
      expect(service.find_by_id_or_label('casting/鋳造')).to include({
        "label" => "casting/鋳造",
        "id" => "casting",
        "active" => true
      })
    end
  end
end
