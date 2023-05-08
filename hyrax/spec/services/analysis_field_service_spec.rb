require 'rails_helper'

RSpec.describe AnalysisFieldService do
  let(:service) { described_class.new }

  describe "#select_active_options" do
    it "returns active terms" do
      expect(service.select_active_options).to include(
        ["bio property/バイオ特性", "bio property"],
        ["crystallograpgy/結晶学", "crystallograpgy"])
    end
  end

  describe "find_by_id" do
    it "returns active term matching id" do
      expect(service.find_by_id('bio property')).to include({
        "label" => "bio property/バイオ特性",
        "id" => "bio property",
        "active" => true
      })
    end
  end

  describe "find_by_label" do
    it "returns active term  matching label" do
      expect(service.find_by_label('bio property/バイオ特性')).to include({
        "label" => "bio property/バイオ特性",
        "id" => "bio property",
        "active" => true
      })
    end
  end

  describe "find_by_id_or_label" do
    it "returns active term matching id or label" do
      expect(service.find_by_id_or_label('bio property/バイオ特性')).to include({
        "label" => "bio property/バイオ特性",
        "id" => "bio property",
        "active" => true
      })
      expect(service.find_by_id_or_label('bio property')).to include({
        "label" => "bio property/バイオ特性",
        "id" => "bio property",
        "active" => true
      })
    end
  end

end
