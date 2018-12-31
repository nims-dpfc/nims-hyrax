require 'rails_helper'

RSpec.describe CharacterizationMethodService do
  let(:service) { described_class.new }

  describe "#select_active_options" do
    it "returns active terms" do
      expect(service.select_active_options).to include(
        ["charge distribution/荷電分布", "charge distribution"],
        ["dilatometry/膨張計", "dilatometry"])
    end
  end
end
