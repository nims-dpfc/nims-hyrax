require 'rails_helper'

RSpec.describe MeasurementEnvironmentService do
  let(:service) { described_class.new }

  describe "#select_active_options" do
    it "returns active terms" do
      expect(service.select_active_options).to include(
        ["in air/空気中", "in air/空気中"],
        ["in liquid/液体中", "in liquid/液体中"])
    end
  end
end
