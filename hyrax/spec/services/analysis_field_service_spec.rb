require 'rails_helper'

RSpec.describe AnalysisFieldService do
  let(:service) { described_class.new }

  describe "#select_active_options" do
    it "returns active terms" do
      expect(service.select_active_options).to include(["bio property/バイオ特性", "bio property/バイオ特性"], ["crystallograpgy/結晶学", "crystallograpgy/結晶学"])
    end
  end
end
