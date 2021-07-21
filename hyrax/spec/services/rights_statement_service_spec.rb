require 'rails_helper'

RSpec.describe RightsStatementService do
  let(:service) { described_class.new }

  describe "#select_active_options" do
    it "returns active terms" do
      expect(service.select_active_options).to include(
        ["In Copyright (No redistribution)", "http://rightsstatements.org/vocab/InC/1.0/"],
        ["Creative Commons BY-NC-ND Attribution-NonCommercial-NoDerivs 4.0 International", "https://creativecommons.org/licenses/by-nc-nd/4.0/"],
        )
    end
  end

  describe "find_by_id" do
    it "returns active term matching id" do
      expect(service.find_by_id('http://rightsstatements.org/vocab/InC/1.0/')).to eq({
        "label" => "In Copyright (No redistribution)",
        "id" => "http://rightsstatements.org/vocab/InC/1.0/",
        "active" => true
      })
    end
  end

  describe "find_by_label" do
    it "returns active term  matching label" do
      expect(service.find_by_label('In Copyright (No redistribution)')).to eq({
        "label" => "In Copyright (No redistribution)",
        "id" => "http://rightsstatements.org/vocab/InC/1.0/",
        "active" => true
      })
    end
  end

  describe "find_by_id_or_label" do
    it "returns active term matching id or label" do
      expect(service.find_by_id_or_label('http://rightsstatements.org/vocab/InC/1.0/')).to eq({
        "label" => "In Copyright (No redistribution)",
        "id" => "http://rightsstatements.org/vocab/InC/1.0/",
        "active" => true
      })
      expect(service.find_by_id_or_label('In Copyright (No redistribution)')).to eq({
        "label" => "In Copyright (No redistribution)",
        "id" => "http://rightsstatements.org/vocab/InC/1.0/",
        "active" => true
      })
    end
  end
end
