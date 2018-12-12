require 'rails_helper'

RSpec.describe ComplexVersion do
  before do
    class ExampleWork < ActiveFedora::Base
      property :complex_version, predicate: ::RDF::URI.new('http://www.w3.org/2002/07/owl#versionInfo'),
        class_name:"ComplexVersion"
      accepts_nested_attributes_for :complex_version
    end
  end
  after do
    Object.send(:remove_const, :ExampleWork)
  end

  it 'has the correct uri' do
    @obj = ExampleWork.new
    @obj.attributes = {
      complex_version_attributes: [
        {
          version: '1.0'
        }
      ]
    }
    expect(@obj.complex_version.first.id).to include('#version')
  end

  it 'creates a version active triple resource with all the attributes' do
    @obj = ExampleWork.new
    @obj.attributes = {
      complex_version_attributes: [
        {
          date: '1978-10-28',
          description: 'Creating the first version',
          identifier: 'id1',
          version: '1.0'
        }
      ]
    }
    expect(@obj.complex_version.first).to be_kind_of ActiveTriples::Resource
    expect(@obj.complex_version.first.date).to eq ['1978-10-28']
    expect(@obj.complex_version.first.description).to eq ['Creating the first version']
    expect(@obj.complex_version.first.identifier).to eq ['id1']
    expect(@obj.complex_version.first.version).to eq ['1.0']
  end

  describe 'when reject_if is a symbol' do
    before do
      class ExampleWork2 < ExampleWork
        include ComplexAttributes
        accepts_nested_attributes_for :complex_version, reject_if: :version_blank
      end
    end
    after do
      Object.send(:remove_const, :ExampleWork2)
    end

    it 'creates a version active triple resource with just the version' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_version_attributes: [
          {
            version: '1.0'
          }
        ]
      }
      expect(@obj.complex_version.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_version.first.version).to eq ['1.0']
      expect(@obj.complex_version.first.date).to be_empty
      expect(@obj.complex_version.first.description).to be_empty
      expect(@obj.complex_version.first.identifier).to be_empty
    end

    it 'rejects a version active triple with no version' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_version_attributes: [
          {
            description: 'Local version',
            identifier: 'id1',
            date: '2018-01-01'
          }
        ]
      }
      expect(@obj.complex_version).to be_empty
    end
  end
end
