require 'rails_helper'

RSpec.describe RightsStatementService do
  let(:service) { described_class.new }

  describe "#select_active_options" do
    it "returns active terms" do
      expect(service.select_active_options).to include(
        ["In Copyright", "http://rightsstatements.org/vocab/InC/1.0/"],
        ["Copyright Not Evaluated", "http://rightsstatements.org/vocab/CNE/1.0/"],
        )
    end
  end

  describe "find_by_id" do
    it "returns active term matching id" do
      expect(service.find_by_id('http://rightsstatements.org/vocab/CNE/1.0/')).to eq({
        "label" => "Copyright Not Evaluated",
        "id" => "http://rightsstatements.org/vocab/CNE/1.0/",
        "active" => true
      })
    end
  end

  describe "find_by_label" do
    it "returns active term  matching label" do
      expect(service.find_by_label('Copyright Not Evaluated')).to eq({
        "label" => "Copyright Not Evaluated",
        "id" => "http://rightsstatements.org/vocab/CNE/1.0/",
        "active" => true
      })
    end
  end

  describe "find_by_id_or_label" do
    it "returns active term matching id or label" do
      expect(service.find_by_id_or_label('http://rightsstatements.org/vocab/CNE/1.0/')).to eq({
        "label" => "Copyright Not Evaluated",
        "id" => "http://rightsstatements.org/vocab/CNE/1.0/",
        "active" => true
      })
      expect(service.find_by_id_or_label('Copyright Not Evaluated')).to eq({
        "label" => "Copyright Not Evaluated",
        "id" => "http://rightsstatements.org/vocab/CNE/1.0/",
        "active" => true
      })
    end
  end
end
