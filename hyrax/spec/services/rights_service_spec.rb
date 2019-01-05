require 'rails_helper'

RSpec.describe RightsService do
  let(:service) { described_class.new }

  describe "#select_active_options" do
    it "returns active terms" do
      expect(service.select_active_options).to include(
        ["Creative Commons BY Attribution 4.0 International", "https://creativecommons.org/licenses/by/4.0/"],
        ["Creative Commons Public Domain Mark 1.0", "http://creativecommons.org/publicdomain/mark/1.0/"],
        )
    end
  end

  describe "find_by_id" do
    it "returns active term matching id" do
      expect(service.find_by_id('http://creativecommons.org/publicdomain/mark/1.0/')).to eq({
        "label" => "Creative Commons Public Domain Mark 1.0",
        "id" => "http://creativecommons.org/publicdomain/mark/1.0/",
        "active" => true
      })
    end
  end

  describe "find_by_label" do
    it "returns active term  matching label" do
      expect(service.find_by_label('Creative Commons Public Domain Mark 1.0')).to eq({
        "label" => "Creative Commons Public Domain Mark 1.0",
        "id" => "http://creativecommons.org/publicdomain/mark/1.0/",
        "active" => true
      })
    end
  end

  describe "find_by_id_or_label" do
    it "returns active term matching id or label" do
      expect(service.find_by_id_or_label('http://creativecommons.org/publicdomain/mark/1.0/')).to eq({
        "label" => "Creative Commons Public Domain Mark 1.0",
        "id" => "http://creativecommons.org/publicdomain/mark/1.0/",
        "active" => true
      })
      expect(service.find_by_id_or_label('Creative Commons Public Domain Mark 1.0')).to eq({
        "label" => "Creative Commons Public Domain Mark 1.0",
        "id" => "http://creativecommons.org/publicdomain/mark/1.0/",
        "active" => true
      })
    end
  end
end
