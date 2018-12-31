require 'rails_helper'

RSpec.describe MaterialTypeService do
  let(:service) { described_class.new }

  describe "#select_active_options" do
    it "returns active terms" do
      expect(service.select_active_options).to include(
        ["ceramics/セラミックス", "ceramics"],
        ["metals and alloys/金属・合金 -- Cu-containing/Cu含有物質", "metals and alloys -- Cu-containing"])
    end
  end
end
