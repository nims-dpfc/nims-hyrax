require 'rails_helper'

RSpec.describe ComputationalMethodService do
  let(:service) { described_class.new }

  describe "#select_active_options" do
    it "returns active terms" do
      expect(service.select_active_options).to include(
        ["CALPHAD/カルパッド", "CALPHAD"],
        ["molecular dynamics/分子動力学", "molecular dynamics"])
    end
  end
end
