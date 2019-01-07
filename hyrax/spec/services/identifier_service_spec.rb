require 'rails_helper'

RSpec.describe IdentifierService do
  let(:service) { described_class.new }

  describe "#select_active_options" do
    it "returns active terms" do
      expect(service.select_active_options).to include(
        ["eduPersonTargetedID", "edu person targeted id"],
        ["Referred Data Identifier - Local", "referred data identifier local"])
    end
  end

  describe "find_by_id" do
    it "returns active term matching id" do
      expect(service.find_by_id('referred data identifier local')).to eq({
        "label" => "Referred Data Identifier - Local",
        "id" => "referred data identifier local",
        "active" => true
      })
    end
  end

  describe "find_by_label" do
    it "returns active term  matching label" do
      expect(service.find_by_label('Referred Data Identifier - Local')).to eq({
        "label" => "Referred Data Identifier - Local",
        "id" => "referred data identifier local",
        "active" => true
      })
    end
  end

  describe "find_by_id_or_label" do
    it "returns active term matching id or label" do
      expect(service.find_by_id_or_label('Referred Data Identifier - Local')).to eq({
        "label" => "Referred Data Identifier - Local",
        "id" => "referred data identifier local",
        "active" => true
      })
      expect(service.find_by_id_or_label('referred data identifier local')).to eq({
        "label" => "Referred Data Identifier - Local",
        "id" => "referred data identifier local",
        "active" => true
      })
    end
  end
end
