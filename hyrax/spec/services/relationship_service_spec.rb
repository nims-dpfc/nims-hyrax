require 'rails_helper'

RSpec.describe RelationshipService do
  let(:service) { described_class.new }

  describe "#select_active_options" do
    it "returns active terms" do
      expect(service.select_active_options).to include(
        ["is supplemented by", "isSupplementedBy"],
        ["is previous version of", "isPreviousVersionOf"],
        )
    end
  end

  describe "find_by_id" do
    it "returns active term matching id" do
      expect(service.find_by_id('isSupplementedBy')).to eq({
        "label" => "is supplemented by",
        "id" => "isSupplementedBy",
        "active" => true
      })
    end
  end

  describe "find_by_label" do
    it "returns active term  matching label" do
      expect(service.find_by_label('is supplemented by')).to eq({
        "label" => "is supplemented by",
        "id" => "isSupplementedBy",
        "active" => true
      })
    end
  end

  describe "find_by_id_or_label" do
    it "returns active term matching id or label" do
      expect(service.find_by_id_or_label('isSupplementedBy')).to eq({
        "label" => "is supplemented by",
        "id" => "isSupplementedBy",
        "active" => true
      })
      expect(service.find_by_id_or_label('is supplemented by')).to eq({
        "label" => "is supplemented by",
        "id" => "isSupplementedBy",
        "active" => true
      })
    end
  end
end
