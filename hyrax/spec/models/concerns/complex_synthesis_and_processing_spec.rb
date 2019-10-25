require 'rails_helper'

RSpec.describe ComplexSynthesisAndProcessing do
  before do
    class ExampleWork < ActiveFedora::Base
      property :complex_synthesis_and_processing, predicate: ::RDF::Vocab::NimsRdp['complex-synthesis-and-processing'],
        class_name: "ComplexSynthesisAndProcessing"
      accepts_nested_attributes_for :complex_synthesis_and_processing
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
          .new({ complex_synthesis_and_processing_attributes: [{ description: 'Foo' }]})
          .complex_synthesis_and_processing
          .first
          .description
    end
    it { is_expected.to eq ['Foo'] }
  end

  it 'has the correct uri' do
    @obj = ExampleWork.new
    @obj.attributes = {
      complex_synthesis_and_processing_attributes: [{
        description: 'synthesis_and_processing 1'
      }]
    }
    expect(@obj.complex_synthesis_and_processing.first.id).to include('#complex-synthesis-and-processing')
  end

  describe "when reject_if is a symbol" do
    before do
      class ExampleWork2 < ExampleWork
        include ComplexValidation
        accepts_nested_attributes_for :complex_synthesis_and_processing, reject_if: :all_blank
      end
    end
    after do
      Object.send(:remove_const, :ExampleWork2)
    end

    it 'creates a synthesis_and_processing active triple resource with description and identifier' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_synthesis_and_processing_attributes: [{
          description: 'chemical composition 12',
          instrument_identifier_attributes: [{
            identifier: ['11223344'],
          }],
          standarized_procedure_attributes: [{
            identifier: ['ewfqwefqwef'],
          }]
        }]
      }
      expect(@obj.complex_synthesis_and_processing.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_synthesis_and_processing.first.standarized_procedure.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_synthesis_and_processing.first.standarized_procedure.first.identifier).to eq ['ewfqwefqwef']
      expect(@obj.complex_synthesis_and_processing.first.instrument_identifier.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_synthesis_and_processing.first.instrument_identifier.first.identifier).to eq ['11223344']
      expect(@obj.complex_synthesis_and_processing.first.description).to eq ['chemical composition 12']
    end

    it 'rejects a synthesis_and_processing active triple with no description' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_synthesis_and_processing_attributes: [{
        }]
      }
      expect(@obj.complex_synthesis_and_processing).to be_empty
    end
  end
end
