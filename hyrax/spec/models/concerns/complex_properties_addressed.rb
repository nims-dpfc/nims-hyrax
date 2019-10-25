require 'rails_helper'

RSpec.describe ComplexPropertiesAddressed do
  before do
    class ExampleWork < ActiveFedora::Base
      property :complex_properties_addressed, predicate: ::RDF::Vocab::NimsRdp.properties_addressed,
        class_name:"ComplexPropertiesAddressed"
      accepts_nested_attributes_for :complex_properties_addressed
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
          .new({ complex_properties_addressed_attributes: [{ arbitrary: 'Foo' }]})
          .complex_properties_addressed
          .first
          .arbitrary
    end
    it { is_expected.to eq ['Foo'] }
  end

  it 'has the correct uri' do
    @obj = ExampleWork.new
    @obj.attributes = {
      complex_properties_addressed_attributes: [{
        complex_identifier_attributes: [{
          identifier: ['ewfqwefqwef'],
        }],
        arbitrary: 'properties_addressed 1'
      }]
    }
    expect(@obj.complex_properties_addressed.first.id).to include('#properties_addressed')
  end

  it 'creates a properties_addressed active triple resource with all the attributes' do
    @obj = ExampleWork.new
    @obj.attributes = {
      complex_properties_addressed_attributes: [{
        arbitrary: 'properties_addressed arbitrary'
      }]
    }
    expect(@obj.complex_properties_addressed.first).to be_kind_of ActiveTriples::Resource
    expect(@obj.complex_properties_addressed.first.id).to include('#properties_addressed')
    expect(@obj.complex_properties_addressed.first.arbitrary).to eq ['properties_addressed arbitrary']
  end

  describe "when reject_if is a symbol" do
    before do
      class ExampleWork2 < ExampleWork
        include ComplexValidation
        accepts_nested_attributes_for :complex_properties_addressed, reject_if: :all_blank
      end
    end
    after do
      Object.send(:remove_const, :ExampleWork2)
    end

    it 'rejects a properties_addressed active triple with no arbitrary' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_properties_addressed_attributes: [{
          arbitrary: ''
        }]
      }
      expect(@obj.complex_properties_addressed).to be_empty
    end
  end
end
