require 'rails_helper'

RSpec.describe StructuralFeatureService do
  let(:service) { described_class.new }

  describe "#select_active_options" do
    it "returns active terms" do
      expect(service.select_active_options).to include(
        ["composites/複合材料 -- structural/構造", "composites -- structural"],
        ["defects/欠陥", "defects"])
    end
  end

  describe "find_by_id" do
    it "returns active term matching id" do
      expect(service.find_by_id('defects')).to include({
        "label" => "defects/欠陥",
        "id" => "defects",
        "active" => true
      })
    end
  end

  describe "find_by_label" do
    it "returns active term  matching label" do
      expect(service.find_by_label('defects/欠陥')).to include({
        "label" => "defects/欠陥",
        "id" => "defects",
        "active" => true
      })
    end
  end

  describe "find_by_id_or_label" do
    it "returns active term matching id or label" do
      expect(service.find_by_id_or_label('defects')).to include({
        "label" => "defects/欠陥",
        "id" => "defects",
        "active" => true
      })
      expect(service.find_by_id_or_label('defects/欠陥')).to include({
        "label" => "defects/欠陥",
        "id" => "defects",
        "active" => true
      })
    end
  end
end
