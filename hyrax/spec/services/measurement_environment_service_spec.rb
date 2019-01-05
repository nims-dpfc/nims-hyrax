require 'rails_helper'

RSpec.describe MeasurementEnvironmentService do
  let(:service) { described_class.new }

  describe "#select_active_options" do
    it "returns active terms" do
      expect(service.select_active_options).to include(
        ["in air/空気中", "in air"],
        ["in liquid/液体中", "in liquid"])
    end
  end

  describe "find_by_id" do
    it "returns active term matching id" do
      expect(service.find_by_id('in air')).to eq({
        "label" => "in air/空気中",
        "id" => "in air",
        "active" => true
      })
    end
  end

  describe "find_by_label" do
    it "returns active term  matching label" do
      expect(service.find_by_label('in air/空気中')).to eq({
        "label" => "in air/空気中",
        "id" => "in air",
        "active" => true
      })
    end
  end

  describe "find_by_id_or_label" do
    it "returns active term matching id or label" do
      expect(service.find_by_id_or_label('in air')).to eq({
        "label" => "in air/空気中",
        "id" => "in air",
        "active" => true
      })
      expect(service.find_by_id_or_label('in air/空気中')).to eq({
        "label" => "in air/空気中",
        "id" => "in air",
        "active" => true
      })
    end
  end
end
