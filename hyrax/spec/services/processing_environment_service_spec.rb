require 'rails_helper'

RSpec.describe ProcessingEnvironmentService do
  let(:service) { described_class.new }

  describe "#select_active_options" do
    it "returns active terms" do
      expect(service.select_active_options).to include(
        ["in liquid/液体中", "in liquid"],
        ["in vacuum/真空中", "in vacuum"])
    end
  end

  describe "find_by_id" do
    it "returns active term matching id" do
      expect(service.find_by_id('in liquid')).to include({
        "label" => "in liquid/液体中",
        "id" => "in liquid",
        "active" => true
      })
    end
  end

  describe "find_by_label" do
    it "returns active term  matching label" do
      expect(service.find_by_label('in liquid/液体中')).to include({
        "label" => "in liquid/液体中",
        "id" => "in liquid",
        "active" => true
      })
    end
  end

  describe "find_by_id_or_label" do
    it "returns active term matching id or label" do
      expect(service.find_by_id_or_label('in liquid')).to include({
        "label" => "in liquid/液体中",
        "id" => "in liquid",
        "active" => true
      })
      expect(service.find_by_id_or_label('in liquid/液体中')).to include({
        "label" => "in liquid/液体中",
        "id" => "in liquid",
        "active" => true
      })
    end
  end
end
