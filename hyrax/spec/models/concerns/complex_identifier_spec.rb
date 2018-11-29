require 'rails_helper'

RSpec.describe ComplexIdentifier do
  before do
    class ExampleWork < ActiveFedora::Base
      property :complex_identifier, predicate: ::RDF::Vocab::MODS.identifierGroup,
        class_name:"ComplexIdentifier"
      accepts_nested_attributes_for :complex_identifier
    end
  end
  after do
    Object.send(:remove_const, :ExampleWork)
  end

  it 'has the correct uri' do
    @obj = ExampleWork.new
    @obj.attributes = {
      complex_identifier_attributes: [
        {
          identifier: '0000-0000-0000-0000'
        }
      ]
    }
    expect(@obj.complex_identifier.first.id).to include('#identifier')
  end

  it 'creates an identifier active triple resource with all the attributes' do
    @obj = ExampleWork.new
    @obj.attributes = {
      complex_identifier_attributes: [
        {
          identifier: '0000-0000-0000-0000',
          scheme: 'uri_of_ORCID_scheme',
          label: 'ORCID'
        }
      ]
    }
    expect(@obj.complex_identifier.first).to be_kind_of ActiveTriples::Resource
    expect(@obj.complex_identifier.first.identifier).to eq ['0000-0000-0000-0000']
    expect(@obj.complex_identifier.first.scheme).to eq ['uri_of_ORCID_scheme']
    expect(@obj.complex_identifier.first.label).to eq ['ORCID']
  end

  describe 'when reject_if is a symbol' do
    before do
      class ExampleWork2 < ExampleWork
        include ComplexAttributes
        accepts_nested_attributes_for :complex_identifier, reject_if: :identifier_blank
      end
    end
    after do
      Object.send(:remove_const, :ExampleWork2)
    end

    it 'creates an identifier active triple resource with just the identifier' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_identifier_attributes: [
          {
            identifier: '1234'
          }
        ]
      }
      expect(@obj.complex_identifier.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_identifier.first.identifier).to eq ['1234']
      expect(@obj.complex_identifier.first.label).to be_empty
      expect(@obj.complex_identifier.first.scheme).to be_empty
    end

    it 'rejects an identifier active triple with no ientifier' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_identifier_attributes: [
          {
            label: 'Local'
          }
        ]
      }
      expect(@obj.complex_identifier).to be_empty
    end
  end
end
