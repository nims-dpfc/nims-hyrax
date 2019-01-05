require 'rails_helper'

RSpec.describe MaterialTypeService do
  let(:service) { described_class.new }

  describe "#select_active_options" do
    it "returns active terms" do
      expect(service.select_active_options).to include(
        ["ceramics/セラミックス", "ceramics"],
        ["metals and alloys/金属・合金 -- Cu-containing/Cu含有物質", "metals and alloys -- Cu-containing"])
    end
  end

  describe "find_by_id" do
    it "returns active term matching id" do
      expect(service.find_by_id('ceramics')).to eq({
        "label" => "ceramics/セラミックス",
        "id" => "ceramics",
        "active" => true
      })
    end
  end

  describe "find_by_label" do
    it "returns active term  matching label" do
      expect(service.find_by_label('ceramics/セラミックス')).to eq({
        "label" => "ceramics/セラミックス",
        "id" => "ceramics",
        "active" => true
      })
    end
  end

  describe "find_by_id_or_label" do
    it "returns active term matching id or label" do
      expect(service.find_by_id_or_label('ceramics')).to eq({
        "label" => "ceramics/セラミックス",
        "id" => "ceramics",
        "active" => true
      })
      expect(service.find_by_id_or_label('ceramics/セラミックス')).to eq({
        "label" => "ceramics/セラミックス",
        "id" => "ceramics",
        "active" => true
      })
    end
  end
end
