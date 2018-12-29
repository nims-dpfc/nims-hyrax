require 'rails_helper'

RSpec.describe ProcessingEnvironmentService do
  let(:service) { described_class.new }

  describe "#select_active_options" do
    it "returns active terms" do
      expect(service.select_active_options).to include(
        ["in liquid/液体中", "in liquid/液体中"],
        ["in vacuum/真空中", "in vacuum/真空中"])
    end
  end
end
