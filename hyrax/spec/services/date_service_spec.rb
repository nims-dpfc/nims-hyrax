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
end
