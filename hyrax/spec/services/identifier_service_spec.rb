require 'rails_helper'

RSpec.describe IdentifierService do
  let(:service) { described_class.new }

  describe "#select_active_options" do
    it "returns active terms" do
      expect(service.select_active_options).to include(
        ["eduPersonTargetedID", "edu person targeted id"],
        ["Referred Identifier - Local", "referred identifier local"])
    end
  end

  describe "find_by_id" do
    it "returns active term matching id" do
      expect(service.find_by_id('referred identifier local')).to include({
        "label" => "Referred Identifier - Local",
        "id" => "referred identifier local",
        "active" => true
      })
    end
  end

  describe "find_by_label" do
    it "returns active term  matching label" do
      expect(service.find_by_label('Identifier - Local')).to include({
        "label" => "Identifier - Local",
        "id" => "identifier local",
        "active" => true
      })
    end
  end

  describe "find_by_id_or_label" do
    it "returns active term matching id or label" do
      expect(service.find_by_id_or_label('Identifier - Persistent')).to include({
        "label" => "Identifier - Persistent",
        "id" => "identifier persistent",
        "active" => true
      })
      expect(service.find_by_id_or_label('identifier persistent')).to include({
        "label" => "Identifier - Persistent",
        "id" => "identifier persistent",
        "active" => true
      })
    end
  end
end
