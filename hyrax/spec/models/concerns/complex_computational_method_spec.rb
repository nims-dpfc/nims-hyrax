require 'rails_helper'

RSpec.describe ComplexComputationalMethod do
  before do
    class ExampleWork < ActiveFedora::Base
      property :complex_computational_method, predicate: ::RDF::Vocab::NimsRdp['complex-computational-method'], class_name: 'ComplexComputationalMethod',
        class_name: "ComplexComputationalMethod"
      accepts_nested_attributes_for :complex_computational_method
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
          .new({ complex_computational_method_attributes: [{ software_name: ['example'] }]})
          .complex_computational_method
          .first
          .software_name
    end
    it { is_expected.to eq ['example'] }
  end

  it 'has the correct uri' do
    @obj = ExampleWork.new
    @obj.attributes = {
      complex_computational_method_attributes: [
        {
          software_name: ['example']
        }
      ]
    }
    expect(@obj.complex_computational_method.first.id).to include('#complex-computational-method')
  end

  it 'creates an computational_method active triple resource with all the attributes' do
    @obj = ExampleWork.new
    @obj.attributes = {
      complex_computational_method_attributes: [
        {
          software_name: ['example']
        }
      ]
    }
    expect(@obj.complex_computational_method.first).to be_kind_of ActiveTriples::Resource
    expect(@obj.complex_computational_method.first.software_name).to eq ['example']
  end
end
