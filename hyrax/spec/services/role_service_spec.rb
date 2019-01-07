require 'rails_helper'

RSpec.describe RoleService do
  let(:service) { described_class.new }

  describe "#select_active_options" do
    it "returns active terms" do
      expect(service.select_active_options).to include(
        ["translator/翻訳者", "translator"],
        ["data curator/データキュレーター", "data curator"],
        )
    end
  end

  describe "find_by_id" do
    it "returns active term matching id" do
      expect(service.find_by_id('translator')).to eq({
        "label" => "translator/翻訳者",
        "id" => "translator",
        "active" => true
      })
    end
  end

  describe "find_by_label" do
    it "returns active term  matching label" do
      expect(service.find_by_label('translator/翻訳者')).to eq({
        "label" => "translator/翻訳者",
        "id" => "translator",
        "active" => true
      })
    end
  end

  describe "find_by_id_or_label" do
    it "returns active term matching id or label" do
      expect(service.find_by_id_or_label('translator')).to eq({
        "label" => "translator/翻訳者",
        "id" => "translator",
        "active" => true
      })
      expect(service.find_by_id_or_label('translator/翻訳者')).to eq({
        "label" => "translator/翻訳者",
        "id" => "translator",
        "active" => true
      })
    end
  end
end
