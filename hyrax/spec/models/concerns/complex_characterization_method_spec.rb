require 'rails_helper'

RSpec.describe ComplexCharacterizationMethod do
  before do
    class ExampleWork < ActiveFedora::Base
      property :complex_characterization_method, predicate: ::RDF::Vocab::NimsRdp['complex-characterization-method'],
        class_name: 'ComplexCharacterizationMethod'
      accepts_nested_attributes_for :complex_characterization_method
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
          .new({ complex_characterization_method_attributes: [{ description: ['example'] }]})
          .complex_characterization_method
          .first
          .description
    end
    it { is_expected.to eq ['example'] }
  end

  it 'has the correct uri' do
    @obj = ExampleWork.new
    @obj.attributes = {
      complex_characterization_method_attributes: [
        {
          description: ['example']
        }
      ]
    }
    expect(@obj.complex_characterization_method.first.id).to include('#complex-characterization-method')
  end

  it 'creates an characterization_method active triple resource with all the attributes' do
    @obj = ExampleWork.new
    @obj.attributes = {
      complex_characterization_method_attributes: [
        {
          description: ['example']
        }
      ]
    }
    expect(@obj.complex_characterization_method.first).to be_kind_of ActiveTriples::Resource
    expect(@obj.complex_characterization_method.first.description).to eq ['example']
  end
end
