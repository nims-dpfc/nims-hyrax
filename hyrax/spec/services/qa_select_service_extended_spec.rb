require 'rails_helper'

RSpec.describe QaSelectServiceExtended do
  let(:service) { described_class.new('identifiers') }

  describe "#find_by_id" do
    subject { service.find_by_id(id) }
    context 'found' do
      let(:id) { 'referred identifier local' }
      it { is_expected.to eql({
          "label" => "Referred Identifier - Local",
          "term" => "Referred Identifier - Local",
          "id" => "referred identifier local",
          "active" => true,
          "uri" => nil
        })
      }
    end
    context 'not found' do
      let(:id) { 'foo bar' }
      it { is_expected.to eql({}) }
    end
  end

  describe '#find_by_label' do
    subject { service.find_by_label(label) }
    context 'found' do
      let(:label) { 'Identifier - Local' }
      it { is_expected.to eql({
          "label" => "Identifier - Local",
          "term" => "Identifier - Local",
          "id" => "identifier local",
          "active" => true,
          "uri" => nil
        })
      }
    end
    context 'not found' do
      let(:label) { 'foo bar' }
      it { is_expected.to eql({}) }
    end
  end

  describe '#find_by_id_or_label' do
    subject { service.find_by_id_or_label(id_or_label) }
    context 'found' do
      context 'label' do
        let(:id_or_label) { 'Identifier - Persistent' }
        it { is_expected.to eql({
              "label" => "Identifier - Persistent",
              "term" => "Identifier - Persistent",
              "id" => "identifier persistent",
              "active" => true,
              "uri" => nil
          })
        }
      end
      context 'id' do
        let(:id_or_label) { 'identifier persistent' }
        it { is_expected.to eql({
              "label" => "Identifier - Persistent",
              "term" => "Identifier - Persistent",
              "id" => "identifier persistent",
              "active" => true,
              "uri" => nil
          })
        }
      end
    end
    context 'not found' do
      let(:id_or_label) { 'foo bar' }
      it { is_expected.to eql({}) }
    end
  end

  describe "#find_any_by_id" do
    let(:service) { described_class.new('rights_statements') }
    subject { service.find_any_by_id(id) }
    context 'inactive' do
      let(:id) { 'http://opensource.org/licenses/MIT' }
      it { is_expected.to eql({
                                "label" => "MIT License",
                                "term" => "MIT License",
                                "id" => "http://opensource.org/licenses/MIT",
                                "active" => false,
                                "uri" => nil
                              })
      }
    end
    context 'active' do
      let(:id) { 'https://creativecommons.org/licenses/by/4.0/legalcode' }
      it { is_expected.to eql({
                                "id" => "https://creativecommons.org/licenses/by/4.0/legalcode",
                                "label" => "Creative Commons Attribution 4.0 International",
                                "term" => "Creative Commons Attribution 4.0 International",
                                "short_label" => "CC-BY-4.0",
                                "human_url" => "https://creativecommons.org/licenses/by/4.0/",
                                "active" => true,
                                "uri" => nil
                              }) }
    end
  end
end
