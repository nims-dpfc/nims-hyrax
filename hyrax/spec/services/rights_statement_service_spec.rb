require 'rails_helper'

RSpec.describe RightsStatementService do
  let(:service) { described_class.new }

  describe "#select_active_options" do
    it "returns active terms" do
      expect(service.select_active_options).to include(
        ["In Copyright", "http://rightsstatements.org/vocab/InC/1.0/"],
        ["Creative Commons Attribution 4.0 International", "https://creativecommons.org/licenses/by/4.0/legalcode"],
        )
    end
  end

  describe "find_by_id" do
    it "returns active term matching id" do
      expect(service.find_by_id('http://rightsstatements.org/vocab/InC/1.0/')).to include({
        "label" => "In Copyright",
        "id" => "http://rightsstatements.org/vocab/InC/1.0/",
        "active" => true
      })
    end
  end

  describe "find_by_label" do
    it "returns active term  matching label" do
      expect(service.find_by_label('In Copyright')).to include({
        "label" => "In Copyright",
        "id" => "http://rightsstatements.org/vocab/InC/1.0/",
        "active" => true
      })
    end
  end

  describe "find_by_id_or_label" do
    it "returns active term matching id or label" do
      expect(service.find_by_id_or_label('http://rightsstatements.org/vocab/InC/1.0/')).to include({
        "label" => "In Copyright",
        "id" => "http://rightsstatements.org/vocab/InC/1.0/",
        "active" => true
      })
      expect(service.find_by_id_or_label('In Copyright')).to include({
        "label" => "In Copyright",
        "id" => "http://rightsstatements.org/vocab/InC/1.0/",
        "active" => true
      })
    end

    describe "find_any_by_id" do
      it "returns active or inactive term matching id" do
        expect(service.find_any_by_id('https://creativecommons.org/licenses/by-nc/4.0/')).to include({
             "label" => "Creative Commons BY-NC Attribution-NonCommercial 4.0 International",
             "id" => "https://creativecommons.org/licenses/by-nc/4.0/",
             "active" => false
           })
        expect(service.find_any_by_id('http://rightsstatements.org/vocab/InC/1.0/')).to include({
           "label" => "In Copyright",
           "id" => "http://rightsstatements.org/vocab/InC/1.0/",
           "active" => true
         })
      end
    end
  end
end
