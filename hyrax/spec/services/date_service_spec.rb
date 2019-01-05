require 'rails_helper'

RSpec.describe DateService do
  let(:service) { described_class.new }

  describe "#select_active_options" do
    it "returns active terms" do
      expect(service.select_active_options).to include(
        ["Accepted", "http://purl.org/dc/terms/dateAccepted"],
        ["Updated", "http://bibframe.org/vocab/changeDate"])
    end
  end

  describe "find_by_id" do
    it "returns active term matching id" do
      expect(service.find_by_id('http://purl.org/dc/terms/dateAccepted')).to eq({
        "label" => "Accepted",
        "id" => "http://purl.org/dc/terms/dateAccepted",
        "active" => true
      })
    end
  end

  describe "find_by_label" do
    it "returns active term  matching label" do
      expect(service.find_by_label('Accepted')).to eq({
        "label" => "Accepted",
        "id" => "http://purl.org/dc/terms/dateAccepted",
        "active" => true
      })
    end
  end

  describe "find_by_id_or_label" do
    it "returns active term matching id or label" do
      expect(service.find_by_id_or_label('http://purl.org/dc/terms/dateAccepted')).to eq({
        "label" => "Accepted",
        "id" => "http://purl.org/dc/terms/dateAccepted",
        "active" => true
      })
      expect(service.find_by_id_or_label('Accepted')).to eq({
        "label" => "Accepted",
        "id" => "http://purl.org/dc/terms/dateAccepted",
        "active" => true
      })
    end
  end
end
