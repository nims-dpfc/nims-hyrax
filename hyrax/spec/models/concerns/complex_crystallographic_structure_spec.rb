require 'rails_helper'

RSpec.describe ComplexCrystallographicStructure do
  before do
    class ExampleWork < ActiveFedora::Base
      property :complex_crystallographic_structure, predicate: ::RDF::Vocab::NimsRdp['chemical-composition'],
        class_name:"ComplexCrystallographicStructure"
      accepts_nested_attributes_for :complex_crystallographic_structure
    end
  end
  after do
    Object.send(:remove_const, :ExampleWork)
  end

  it 'has the correct uri' do
    @obj = ExampleWork.new
    @obj.attributes = {
      complex_crystallographic_structure_attributes: [{
        complex_identifier_attributes: [{
          identifier: ['ewfqwefqwef'],
        }],
        description: 'crystallographic_structure 1'
      }]
    }
    expect(@obj.complex_crystallographic_structure.first.id).to include('#crystallographic_structure')
  end

  it 'creates an crystallographic structure active triple resource with all the attributes' do
    @obj = ExampleWork.new
    @obj.attributes = {
      complex_crystallographic_structure_attributes: [{
        description: 'crystallographic_structure description',
        complex_identifier_attributes: [{
          identifier: ['123456'],
          label: ['Local']
        }]
      }]
    }
    expect(@obj.complex_crystallographic_structure.first).to be_kind_of ActiveTriples::Resource
    expect(@obj.complex_crystallographic_structure.first.description).to eq ['crystallographic_structure description']
    expect(@obj.complex_crystallographic_structure.first.complex_identifier.first).to be_kind_of ActiveTriples::Resource
    expect(@obj.complex_crystallographic_structure.first.complex_identifier.first.identifier).to eq ['123456']
    expect(@obj.complex_crystallographic_structure.first.complex_identifier.first.label).to eq ['Local']
  end

  describe "when reject_if is a symbol" do
    before do
      class ExampleWork2 < ExampleWork
        include ComplexValidation
        accepts_nested_attributes_for :complex_crystallographic_structure, reject_if: :identifier_description_blank
      end
    end
    after do
      Object.send(:remove_const, :ExampleWork2)
    end

    it 'creates an crystallographic structure active triple resource with description and identifier' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_crystallographic_structure_attributes: [{
          description: 'chemical composition 12',
          complex_identifier_attributes: [{
            identifier: ['ewfqwefqwef'],
          }]
        }]
      }
      expect(@obj.complex_crystallographic_structure.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_crystallographic_structure.first.complex_identifier.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_crystallographic_structure.first.complex_identifier.first.identifier).to eq ['ewfqwefqwef']
      expect(@obj.complex_crystallographic_structure.first.description).to eq ['chemical composition 12']
    end

    it 'rejects an crystallographic structure active triple with no description' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_crystallographic_structure_attributes: [{
          complex_identifier_attributes: [{
            identifier: ['ewfqwefqwef'],
          }]
        }]
      }
      expect(@obj.complex_crystallographic_structure).to be_empty
    end

    it 'rejects an crystallographic structure active triple with no identifier' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_crystallographic_structure_attributes: [{
          description: 'composition 1'
        }]
      }
      expect(@obj.complex_crystallographic_structure).to be_empty
      @obj2 = ExampleWork2.new
      @obj2.attributes = {
        complex_crystallographic_structure_attributes: [{
          description: 'crystallographic_structure description',
          complex_identifier_attributes: [{
            label: ['Local']
          }]
        }]
      }
      expect(@obj2.complex_crystallographic_structure).to be_empty
    end
  end
end
