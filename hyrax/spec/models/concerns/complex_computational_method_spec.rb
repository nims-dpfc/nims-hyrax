require 'rails_helper'

RSpec.describe ComplexComputationalMethod do
  before do
    class ExampleWork < ActiveFedora::Base
      property :complex_computational_method, predicate: ::RDF::Vocab::NimsRdp['computational_method'], class_name:"ComplexComputationalMethod"
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
          .new({ complex_computational_method_attributes: [{ description: 'ComputationalMethod 1' }]})
          .complex_computational_method
          .first
          .description
    end
    it { is_expected.to eq ['ComputationalMethod 1'] }
  end

  context 'accepts valid complex_computational_method_attributes' do
    subject do
      ExampleWork
          .new({ complex_computational_method_attributes: complex_computational_method_attributes })
          .complex_computational_method
          .first
    end

    context 'with all the attributes' do
      let(:complex_computational_method_attributes) do
        [{
          category_vocabulary: 'http://example.com/entry/Q12345',
          category_description: 'example',
          calculated_at: '2023-01-01 00:00:00',
          description: 'ComputationalMethod description'
        }]
      end
      it 'creates an computational_method active triple resource with all the attributes' do
        expect(subject).to be_kind_of ActiveTriples::Resource
        expect(subject.category_vocabulary).to eq ['http://example.com/entry/Q12345']
        expect(subject.category_description).to eq ['example']
        expect(subject.calculated_at).to eq ['2023-01-01 00:00:00']
        expect(subject.description).to eq ['ComputationalMethod description']
      end
    end
  end
end
