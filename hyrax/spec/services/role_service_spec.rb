require 'rails_helper'

RSpec.describe RoleService do
  let(:service) { described_class.new }

  describe "#select_active_options" do
    it "returns active terms" do
      expect(service.select_active_options).to include(
        ["translator/翻訳者", "translator/翻訳者"],
        ["data curator/データキュレーター", "data curator/データキュレーター"],
        )
    end
  end
end
