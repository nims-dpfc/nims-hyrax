require 'rails_helper'

RSpec.describe PropertiesAddressedService do
  let(:service) { described_class.new }

  describe "#select_active_options" do
    it "returns active terms" do
      expect(service.select_active_options).to include(
        ["chemical/化学的", "chemical"],
        ["corrosion/腐食", "corrosion"])
    end
  end
end
