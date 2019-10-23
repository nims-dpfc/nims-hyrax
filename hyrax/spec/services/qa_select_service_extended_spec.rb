require 'rails_helper'

RSpec.describe QaSelectServiceExtended do
  let(:service) { described_class.new('identifiers') }

  describe "#find_by_id" do
    subject { service.find_by_id(id) }
    context 'found' do
      let(:id) { 'referred identifier local' }
      it { is_expected.to eql({
          "label" => "Referred Identifier - Local",
          "id" => "referred identifier local",
          "active" => true
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
          "id" => "identifier local",
          "active" => true
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
              "id" => "identifier persistent",
              "active" => true
          })
        }
      end
      context 'id' do
        let(:id_or_label) { 'identifier persistent' }
        it { is_expected.to eql({
              "label" => "Identifier - Persistent",
              "id" => "identifier persistent",
              "active" => true
          })
        }
      end
    end
    context 'not found' do
      let(:id_or_label) { 'foo bar' }
      it { is_expected.to eql({}) }
    end
  end
end
