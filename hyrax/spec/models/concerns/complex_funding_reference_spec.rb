require 'rails_helper'

RSpec.describe ComplexFundingReference do
  before do
    class ExampleWork < ActiveFedora::Base
      property :complex_funding_reference, predicate: ::RDF::Vocab::DataCite.fundref,
               class_name:"ComplexFundingReference"
      accepts_nested_attributes_for :complex_funding_reference
    end
  end
  after do
    Object.send(:remove_const, :ExampleWork)
  end

  context 'uri with a #' do
    before do
      # special hack to force code path for testing
      allow_any_instance_of(RDF::Node).to receive(:node?) { false }
      allow_any_instance_of(RDF::Node).to receive(:start_with?) { true }
    end
    subject do
      ExampleWork
        .new({ complex_funding_reference_attributes: [{funder_identifier: '12345'}]})
        .complex_funding_reference
        .first
        .date
    end
    it { is_expected.to eq ['12345'] }
  end

  it 'has the correct uri' do
    @obj = ExampleWork.new
    @obj.attributes = {
      complex_funding_reference_attributes: [
        {
          funder_identifier: '12345'
        }
      ]
    }
    expect(@obj.complex_funding_reference.first.id).to include('#fundref')
  end

  it 'creates a fund ref active triple resource with all the attributes' do
    @obj = ExampleWork.new
    @obj.attributes = {
      complex_funding_reference_attributes: [
        {
          funder_identifier: '12456',
          funder_name: 'Funder name',
          award_number: 'a323',
          award_title: 'Award title for a323'
        }
      ]
    }
    expect(@obj.complex_funding_reference.first).to be_kind_of ActiveTriples::Resource
    expect(@obj.complex_funding_reference.first.funder_identifier).to eq ['12456']
    expect(@obj.complex_funding_reference.first.funder_name).to eq ['Funder name']
    expect(@obj.complex_funding_reference.first.award_number).to eq ['a323']
    expect(@obj.complex_funding_reference.first.award_title).to eq ['Award title for a323']
  end
end
