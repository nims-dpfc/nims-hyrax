require 'rails_helper'

RSpec.describe ComplexStateOfMatter do
  before do
    class ExampleWork < ActiveFedora::Base
      property :complex_state_of_matter, predicate: ::RDF::Vocab::NimsRdp['state-of-matter'],
        class_name:"ComplexStateOfMatter"
      accepts_nested_attributes_for :complex_state_of_matter
    end
  end
  after do
    Object.send(:remove_const, :ExampleWork)
  end

  it 'has the correct uri' do
    @obj = ExampleWork.new
    @obj.attributes = {
      complex_state_of_matter_attributes: [{
        complex_identifier_attributes: [{
          identifier: ['ewfqwefqwef'],
        }],
        description: 'state of matter 1'
      }]
    }
    expect(@obj.complex_state_of_matter.first.id).to include('#state_of_matter')
  end

  it 'creates a state of matter active triple resource with all the attributes' do
    @obj = ExampleWork.new
    @obj.attributes = {
      complex_state_of_matter_attributes: [{
        description: 'state of matter description',
        complex_identifier_attributes: [{
          identifier: ['123456'],
          label: ['Local']
        }]
      }]
    }
    expect(@obj.complex_state_of_matter.first).to be_kind_of ActiveTriples::Resource
    expect(@obj.complex_state_of_matter.first.id).to include('#state_of_matter')
    expect(@obj.complex_state_of_matter.first.description).to eq ['state of matter description']
    expect(@obj.complex_state_of_matter.first.complex_identifier.first).to be_kind_of ActiveTriples::Resource
    expect(@obj.complex_state_of_matter.first.complex_identifier.first.identifier).to eq ['123456']
    expect(@obj.complex_state_of_matter.first.complex_identifier.first.label).to eq ['Local']
  end

  describe "when reject_if is a symbol" do
    before do
      class ExampleWork2 < ExampleWork
        include ComplexValidation
        accepts_nested_attributes_for :complex_state_of_matter, reject_if: :identifier_description_blank
      end
    end
    after do
      Object.send(:remove_const, :ExampleWork2)
    end

    it 'creates a state of matter active triple resource with description and identifier' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_state_of_matter_attributes: [{
          description: 'chemical composition 12',
          complex_identifier_attributes: [{
            identifier: ['ewfqwefqwef'],
          }]
        }]
      }
      expect(@obj.complex_state_of_matter.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_state_of_matter.first.complex_identifier.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_state_of_matter.first.complex_identifier.first.identifier).to eq ['ewfqwefqwef']
      expect(@obj.complex_state_of_matter.first.description).to eq ['chemical composition 12']
    end

    it 'rejects a state of matter active triple with no description' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_state_of_matter_attributes: [{
          complex_identifier_attributes: [{
            identifier: ['ewfqwefqwef'],
          }]
        }]
      }
      expect(@obj.complex_state_of_matter).to be_empty
    end

    it 'rejects a state of matter active triple with no identifier' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_state_of_matter_attributes: [{
          description: 'composition 1'
        }]
      }
      expect(@obj.complex_state_of_matter).to be_empty
      @obj2 = ExampleWork2.new
      @obj2.attributes = {
        complex_state_of_matter_attributes: [{
          description: 'state of matter description',
          complex_identifier_attributes: [{
            label: ['Local']
          }]
        }]
      }
      expect(@obj2.complex_state_of_matter).to be_empty
    end
  end
end
