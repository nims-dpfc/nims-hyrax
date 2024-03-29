require 'rails_helper'

RSpec.describe ComplexExperimentalMethod do
  before do
    class ExampleWork < ActiveFedora::Base
      property :complex_experimental_method, predicate: ::RDF::Vocab::NimsRdp['experimental_method'], class_name:"ComplexExperimentalMethod"
      accepts_nested_attributes_for :complex_experimental_method
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
          .new({ complex_experimental_method_attributes: [{ description: 'ExperimentalMethod 1' }]})
          .complex_experimental_method
          .first
          .description
    end
    it { is_expected.to eq ['ExperimentalMethod 1'] }
  end

  context 'accepts valid complex_experimental_method_attributes' do
    subject do
      ExampleWork
          .new({ complex_experimental_method_attributes: complex_experimental_method_attributes })
          .complex_experimental_method
          .first
    end

    context 'with all the attributes' do
      let(:complex_experimental_method_attributes) do
        [{
          category_vocabulary: 'http://vocabulary.example.jp/Q12345',
          category_description: 'example',
          analysis_field_vocabulary: 'http://vocabulary.example.jp/Q4561',
          analysis_field_description: 'Vocabulary 4561',
          measurement_environment_vocabulary: 'http://vocabulary.example.jp/Q4562',
          standarized_procedure_vocabulary: 'http://vocabulary.example.jp/Q4563',
          measured_at: '2023-01-01 00:00:00',
          description: 'ExperimentalMethod description'
        }]
      end
      it 'creates an experimental_method active triple resource with all the attributes' do
        expect(subject).to be_kind_of ActiveTriples::Resource
        expect(subject.category_vocabulary).to eq ['http://vocabulary.example.jp/Q12345']
        expect(subject.category_description).to eq ['example']
        expect(subject.analysis_field_vocabulary).to eq ['http://vocabulary.example.jp/Q4561']
        expect(subject.analysis_field_description).to eq ['Vocabulary 4561']
        expect(subject.measurement_environment_vocabulary).to eq ['http://vocabulary.example.jp/Q4562']
        expect(subject.standarized_procedure_vocabulary).to eq ['http://vocabulary.example.jp/Q4563']
        expect(subject.measured_at).to eq ['2023-01-01 00:00:00']
        expect(subject.description).to eq ['ExperimentalMethod description']
      end
    end
  end
end
