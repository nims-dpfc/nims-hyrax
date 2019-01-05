require 'rails_helper'

RSpec.describe PropertiesAddressedService do
  let(:service) { described_class.new }

  describe "#select_active_options" do
    it "returns active terms" do
      expect(service.select_active_options).to include(
        ["chemical/化学的", "chemical"],
        ["corrosion/腐食", "corrosion"])
    end
  end

  describe "find_by_id" do
    it "returns active term matching id" do
      expect(service.find_by_id('chemical')).to eq({
        "label" => "chemical/化学的",
        "id" => "chemical",
        "active" => true
      })
    end
  end

  describe "find_by_label" do
    it "returns active term  matching label" do
      expect(service.find_by_label('chemical/化学的')).to eq({
        "label" => "chemical/化学的",
        "id" => "chemical",
        "active" => true
      })
    end
  end

  describe "find_by_id_or_label" do
    it "returns active term matching id or label" do
      expect(service.find_by_id_or_label('chemical')).to eq({
        "label" => "chemical/化学的",
        "id" => "chemical",
        "active" => true
      })
      expect(service.find_by_id_or_label('chemical/化学的')).to eq({
        "label" => "chemical/化学的",
        "id" => "chemical",
        "active" => true
      })
    end
  end
end
