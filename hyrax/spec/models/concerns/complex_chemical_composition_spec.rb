require 'rails_helper'

RSpec.describe ComplexChemicalComposition do
  before do
    class ExampleWork < ActiveFedora::Base
      property :complex_chemical_composition, predicate: ::RDF::Vocab::NimsRdp['chemical-composition'],
        class_name:"ComplexChemicalComposition"
      accepts_nested_attributes_for :complex_chemical_composition
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
          .new({ complex_chemical_composition_attributes: [{ description: 'chemical_composition 1' }]})
          .complex_chemical_composition
          .first
          .description
    end
    it { is_expected.to eq ['chemical_composition 1'] }
  end

  it 'has the correct uri' do
    @obj = ExampleWork.new
    @obj.attributes = {
      complex_chemical_composition_attributes: [{
        complex_identifier_attributes: [{
          identifier: ['ewfqwefqwef'],
        }],
        description: 'chemical_composition 1'
      }]
    }
    expect(@obj.complex_chemical_composition.first.id).to include('#chemical_composition')
  end

  it 'creates an chemical_composition active triple resource with all the attributes' do
    @obj = ExampleWork.new
    @obj.attributes = {
      complex_chemical_composition_attributes: [{
        description: 'chemical_composition description',
        complex_identifier_attributes: [{
          identifier: ['123456'],
          label: ['Local']
        }]
      }]
    }
    expect(@obj.complex_chemical_composition.first).to be_kind_of ActiveTriples::Resource
    expect(@obj.complex_chemical_composition.first.description).to eq ['chemical_composition description']
    expect(@obj.complex_chemical_composition.first.complex_identifier.first).to be_kind_of ActiveTriples::Resource
    expect(@obj.complex_chemical_composition.first.complex_identifier.first.identifier).to eq ['123456']
    expect(@obj.complex_chemical_composition.first.complex_identifier.first.label).to eq ['Local']
  end

  describe "when reject_if is a symbol" do
    before do
      class ExampleWork2 < ExampleWork
        include ComplexValidation
        accepts_nested_attributes_for :complex_chemical_composition, reject_if: :identifier_description_blank
      end
    end
    after do
      Object.send(:remove_const, :ExampleWork2)
    end

    it 'creates an chemical_composition active triple resource with description and identifier' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_chemical_composition_attributes: [{
          description: 'chemical composition 12',
          complex_identifier_attributes: [{
            identifier: ['ewfqwefqwef'],
          }]
        }]
      }
      expect(@obj.complex_chemical_composition.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_chemical_composition.first.complex_identifier.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_chemical_composition.first.complex_identifier.first.identifier).to eq ['ewfqwefqwef']
      expect(@obj.complex_chemical_composition.first.description).to eq ['chemical composition 12']
    end

    it 'rejects an chemical_composition active triple with no description' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_chemical_composition_attributes: [{
          complex_identifier_attributes: [{
            identifier: ['ewfqwefqwef'],
          }]
        }]
      }
      expect(@obj.complex_chemical_composition).to be_empty
    end

    it 'rejects an chemical_composition active triple with no identifier' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_chemical_composition_attributes: [{
          description: 'composition 1'
        }]
      }
      expect(@obj.complex_chemical_composition).to be_empty
      @obj2 = ExampleWork2.new
      @obj2.attributes = {
        complex_chemical_composition_attributes: [{
          description: 'chemical_composition description',
          complex_identifier_attributes: [{
            label: ['Local']
          }]
        }]
      }
      expect(@obj2.complex_chemical_composition).to be_empty
    end
  end
end
