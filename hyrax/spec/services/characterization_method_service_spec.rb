require 'rails_helper'

RSpec.describe CharacterizationMethodService do
  let(:service) { described_class.new }

  describe "#select_active_options" do
    it "returns active terms" do
      expect(service.select_active_options).to include(
        ["charge distribution/荷電分布", "charge distribution"],
        ["dilatometry/膨張計", "dilatometry"])
    end
  end

  describe "find_by_id" do
    it "returns active term matching id" do
      expect(service.find_by_id('charge distribution')).to include({
        "label" => "charge distribution/荷電分布",
        "id" => "charge distribution",
        "active" => true
      })
    end
  end

  describe "find_by_label" do
    it "returns active term  matching label" do
      expect(service.find_by_label('charge distribution/荷電分布')).to include({
        "label" => "charge distribution/荷電分布",
        "id" => "charge distribution",
        "active" => true
      })
    end
  end

  describe "find_by_id_or_label" do
    it "returns active term matching id or label" do
      expect(service.find_by_id_or_label('charge distribution/荷電分布')).to include({
        "label" => "charge distribution/荷電分布",
        "id" => "charge distribution",
        "active" => true
      })
      expect(service.find_by_id_or_label('charge distribution')).to include({
        "label" => "charge distribution/荷電分布",
        "id" => "charge distribution",
        "active" => true
      })
    end
  end

end
