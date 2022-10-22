require 'rails_helper'

RSpec.describe DataOriginService do
  let(:service) { described_class.new }

  describe "#select_active_options" do
    it "returns active terms" do
      expect(service.select_active_options).to include(
        ["experiments/実験", "experiments"],
        ["informatics and data science/情報・データ科学", "informatics and data science"])
    end
  end

  describe "find_by_id" do
    it "returns active term matching id" do
      expect(service.find_by_id('experiments')).to include({
        "label" => "experiments/実験",
        "id" => "experiments",
        "active" => true
      })
    end
  end

  describe "find_by_label" do
    it "returns active term  matching label" do
      expect(service.find_by_label('experiments/実験')).to include({
        "label" => "experiments/実験",
        "id" => "experiments",
        "active" => true
      })
    end
  end

  describe "find_by_id_or_label" do
    it "returns active term matching id or label" do
      expect(service.find_by_id_or_label('experiments/実験')).to include({
        "label" => "experiments/実験",
        "id" => "experiments",
        "active" => true
      })
      expect(service.find_by_id_or_label('experiments')).to include({
        "label" => "experiments/実験",
        "id" => "experiments",
        "active" => true
      })
    end
  end
end
