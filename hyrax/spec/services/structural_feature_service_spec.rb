require 'rails_helper'

RSpec.describe StructuralFeatureService do
  let(:service) { described_class.new }

  describe "#select_active_options" do
    it "returns active terms" do
      expect(service.select_active_options).to include(
        ["composites/複合材料 -- structural/構造", "composites -- structural"],
        ["defects/欠陥", "defects"])
    end
  end
end
