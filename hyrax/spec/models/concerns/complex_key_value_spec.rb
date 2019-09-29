require 'rails_helper'

RSpec.describe ComplexKeyValue do
  before do
    class ExampleWork < ActiveFedora::Base
      property :custom_property, predicate: ::RDF::Vocab::NimsRdp['custom-properties'],
        class_name:"ComplexKeyValue"
      accepts_nested_attributes_for :custom_property
    end
  end
  after do
    Object.send(:remove_const, :ExampleWork)
  end

  it 'has the correct uri' do
    @obj = ExampleWork.new
    @obj.attributes = {
      custom_property_attributes: [
        {
          label: 'Full name',
          description: 'My full name is ...'
        }
      ]
    }
    expect(@obj.custom_property.first.id).to include('#key_value')
  end

  it 'creates a custom property (additional metadata) active triple resource with all the attributes' do
    @obj = ExampleWork.new
    @obj.attributes = {
      custom_property_attributes: [
        {
          label: 'Full name',
          description: 'My full name is ...'
        }
      ]
    }
    expect(@obj.custom_property.first).to be_kind_of ActiveTriples::Resource
    expect(@obj.custom_property.first.label).to eq ['Full name']
    expect(@obj.custom_property.first.description).to eq ['My full name is ...']
  end

  describe 'when reject_if is a symbol' do
    before do
      class ExampleWork2 < ExampleWork
        include ComplexValidation
        accepts_nested_attributes_for :custom_property, reject_if: :key_value_blank
      end
    end
    after do
      Object.send(:remove_const, :ExampleWork2)
    end

    it 'rejects a custom property (additional metadata) active triple with no label' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        custom_property_attributes: [
          {
            description: 'Local date'
          }
        ]
      }
      expect(@obj.custom_property).to be_empty
    end

    it 'rejects a custom property (additional metadata) active triple with no description' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        custom_property_attributes: [
          {
            label: 'Local date'
          }
        ]
      }
      expect(@obj.custom_property).to be_empty
    end
  end
end
