require 'rails_helper'

RSpec.describe ManuscriptTypeService do
  let(:service) { described_class.new }

  describe "#select_active_options" do
    it "returns active terms" do
      expect(service.select_active_options).to include(
        ["Author's original (Preprint)", "Original"],
        ["Proof", "Proof"])
    end
  end

  describe "find_by_id" do
    it "returns active term matching id" do
      expect(service.find_by_id('Accepted')).to eq({
        "label" => "Accepted manuscript",
        "id" => "Accepted",
        "active" => true
      })
    end
  end

  describe "find_by_label" do
    it "returns active term  matching label" do
      expect(service.find_by_label('Accepted manuscript')).to eq({
        "label" => "Accepted manuscript",
        "id" => "Accepted",
        "active" => true
      })
    end
  end

  describe "find_by_id_or_label" do
    it "returns active term matching id or label" do
      expect(service.find_by_id_or_label('Accepted')).to eq({
        "label" => "Accepted manuscript",
        "id" => "Accepted",
        "active" => true
      })
      expect(service.find_by_id_or_label('Accepted manuscript')).to eq({
        "label" => "Accepted manuscript",
        "id" => "Accepted",
        "active" => true
      })
    end
  end
end
