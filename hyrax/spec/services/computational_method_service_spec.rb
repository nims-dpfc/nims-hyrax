require 'rails_helper'

RSpec.describe ComputationalMethodService do
  let(:service) { described_class.new }

  describe "#select_active_options" do
    it "returns active terms" do
      expect(service.select_active_options).to include(
        ["CALPHAD/カルパッド", "CALPHAD"],
        ["molecular dynamics/分子動力学", "molecular dynamics"])
    end
  end

  describe "find_by_id" do
    it "returns active term matching id" do
      expect(service.find_by_id('CALPHAD')).to eq({
        "label" => "CALPHAD/カルパッド",
        "id" => "CALPHAD",
        "active" => true
      })
    end
  end

  describe "find_by_label" do
    it "returns active term  matching label" do
      expect(service.find_by_label('CALPHAD/カルパッド')).to eq({
        "label" => "CALPHAD/カルパッド",
        "id" => "CALPHAD",
        "active" => true
      })
    end
  end

  describe "find_by_id_or_label" do
    it "returns active term matching id or label" do
      expect(service.find_by_id_or_label('CALPHAD/カルパッド')).to eq({
        "label" => "CALPHAD/カルパッド",
        "id" => "CALPHAD",
        "active" => true
      })
      expect(service.find_by_id_or_label('CALPHAD')).to eq({
        "label" => "CALPHAD/カルパッド",
        "id" => "CALPHAD",
        "active" => true
      })
    end
  end
end
