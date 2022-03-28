require 'rails_helper'

RSpec.describe Hyrax::WorkThumbnailPathService do
  let(:service) { described_class }
  before(:each) do
    service.prepend Hyrax::NimsThumbnailPathService
  end

  describe "default_image" do
    it "returns the path to mdr-default.png" do
      expect(service.default_image).to eq "/assets/mdr-default-60f9f544d1af015df85c14718210b56b8525e2b8d87787a1d14789c4e1120191.png"
    end
  end
end
