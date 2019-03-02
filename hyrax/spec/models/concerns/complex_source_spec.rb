require 'rails_helper'

RSpec.describe ComplexSource do
  before do
    class ExampleWork < ActiveFedora::Base
      property :complex_source, predicate: ::RDF::Vocab::ESciDocPublication.source, class_name:"ComplexSource"
      accepts_nested_attributes_for :complex_source
    end
  end
  after do
    Object.send(:remove_const, :ExampleWork)
  end

  it 'creates a complex source active triple resource with an id and all properties' do
    @obj = ExampleWork.new
    @obj.attributes = {
      complex_source_attributes: [
        {
          alternative_title: 'Sub title for journal',
          complex_person_attributes: [{
            name: 'AR',
            role: 'Editor'
          }],
          end_page: '12',
          complex_identifier_attributes: [{
            identifier: '1234567',
            scheme: 'Local'
          }],
          issue: '34',
          sequence_number: '1.2.2',
          start_page: '4',
          title: 'Test journal',
          total_number_of_pages: '8',
          volume: '3'
        }
      ]
    }
    expect(@obj.complex_source.first).to be_kind_of ActiveTriples::Resource
    expect(@obj.complex_source.first.alternative_title).to eq ['Sub title for journal']
    expect(@obj.complex_source.first.complex_person.first.name).to eq ['AR']
    expect(@obj.complex_source.first.complex_person.first.role).to eq ['Editor']
    expect(@obj.complex_source.first.end_page).to eq ['12']
    expect(@obj.complex_source.first.complex_identifier.first.identifier).to eq ['1234567']
    expect(@obj.complex_source.first.complex_identifier.first.scheme).to eq ['Local']
    expect(@obj.complex_source.first.issue).to eq ['34']
    expect(@obj.complex_source.first.sequence_number).to eq ['1.2.2']
    expect(@obj.complex_source.first.start_page).to eq ['4']
    expect(@obj.complex_source.first.title).to eq ['Test journal']
    expect(@obj.complex_source.first.total_number_of_pages).to eq ['8']
    expect(@obj.complex_source.first.volume).to eq ['3']
  end

  it 'has the correct uri' do
    @obj = ExampleWork.new
    @obj.attributes = {
      complex_source_attributes: [
        {
          title: 'Test journal'
        }
      ]
    }
    expect(@obj.complex_source.first.id).to include('#source')
  end

  describe "when reject_if is a symbol" do
    before do
      class ExampleWork2 < ExampleWork
        accepts_nested_attributes_for :complex_source, reject_if: :all_blank
      end
    end
    after do
      Object.send(:remove_const, :ExampleWork2)
    end

    it 'creates a source active triple resource with title' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_source_attributes: [
          {
            title: 'Anamika'
          }
        ]
      }
      expect(@obj.complex_source.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_source.first.alternative_title).to be_empty
      expect(@obj.complex_source.first.title).to eq ['Anamika']
      expect(@obj.complex_source.first.complex_person).to be_empty
      expect(@obj.complex_source.first.end_page).to be_empty
      expect(@obj.complex_source.first.complex_identifier).to be_empty
      expect(@obj.complex_source.first.issue).to be_empty
      expect(@obj.complex_source.first.sequence_number).to be_empty
      expect(@obj.complex_source.first.start_page).to be_empty
      expect(@obj.complex_source.first.total_number_of_pages).to be_empty
      expect(@obj.complex_source.first.volume).to be_empty
    end

    it 'creates a source active triple resource with complex_person' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_source_attributes: [
          {
            complex_person_attributes: [{name: 'Anamika'}]
          }
        ]
      }
      expect(@obj.complex_source.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_source.first.alternative_title).to be_empty
      expect(@obj.complex_source.first.title).to be_empty
      expect(@obj.complex_source.first.complex_person.first.name).to eq ['Anamika']
      expect(@obj.complex_source.first.end_page).to be_empty
      expect(@obj.complex_source.first.complex_identifier).to be_empty
      expect(@obj.complex_source.first.issue).to be_empty
      expect(@obj.complex_source.first.sequence_number).to be_empty
      expect(@obj.complex_source.first.start_page).to be_empty
      expect(@obj.complex_source.first.total_number_of_pages).to be_empty
      expect(@obj.complex_source.first.volume).to be_empty
    end

    it 'creates a source active triple resource with complex_identifier' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_source_attributes: [
          {
            complex_identifier_attributes: [{identifier: '1234567'}]
          }
        ]
      }
      expect(@obj.complex_source.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_source.first.alternative_title).to be_empty
      expect(@obj.complex_source.first.title).to be_empty
      expect(@obj.complex_source.first.complex_person).to be_empty
      expect(@obj.complex_source.first.end_page).to be_empty
      expect(@obj.complex_source.first.complex_identifier.first.identifier).to eq ['1234567']
      expect(@obj.complex_source.first.issue).to be_empty
      expect(@obj.complex_source.first.sequence_number).to be_empty
      expect(@obj.complex_source.first.start_page).to be_empty
      expect(@obj.complex_source.first.total_number_of_pages).to be_empty
      expect(@obj.complex_source.first.volume).to be_empty
    end

    it 'creates a source active triple resource with issue' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_source_attributes: [
          {
            issue: '12'
          }
        ]
      }
      expect(@obj.complex_source.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_source.first.alternative_title).to be_empty
      expect(@obj.complex_source.first.title).to be_empty
      expect(@obj.complex_source.first.complex_person).to be_empty
      expect(@obj.complex_source.first.end_page).to be_empty
      expect(@obj.complex_source.first.complex_identifier).to be_empty
      expect(@obj.complex_source.first.issue).to eq ['12']
      expect(@obj.complex_source.first.sequence_number).to be_empty
      expect(@obj.complex_source.first.start_page).to be_empty
      expect(@obj.complex_source.first.total_number_of_pages).to be_empty
      expect(@obj.complex_source.first.volume).to be_empty
    end

    it 'creates a source active triple resource with sequence_number' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_source_attributes: [
          {
            sequence_number: '1.45'
          }
        ]
      }
      expect(@obj.complex_source.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_source.first.alternative_title).to be_empty
      expect(@obj.complex_source.first.title).to be_empty
      expect(@obj.complex_source.first.complex_person).to be_empty
      expect(@obj.complex_source.first.end_page).to be_empty
      expect(@obj.complex_source.first.complex_identifier).to be_empty
      expect(@obj.complex_source.first.issue).to be_empty
      expect(@obj.complex_source.first.sequence_number).to eq ['1.45']
      expect(@obj.complex_source.first.start_page).to be_empty
      expect(@obj.complex_source.first.total_number_of_pages).to be_empty
      expect(@obj.complex_source.first.volume).to be_empty
    end

    it 'creates a source active triple resource with volume' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_source_attributes: [
          {
            volume: '145'
          }
        ]
      }
      expect(@obj.complex_source.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_source.first.alternative_title).to be_empty
      expect(@obj.complex_source.first.title).to be_empty
      expect(@obj.complex_source.first.complex_person).to be_empty
      expect(@obj.complex_source.first.end_page).to be_empty
      expect(@obj.complex_source.first.complex_identifier).to be_empty
      expect(@obj.complex_source.first.issue).to be_empty
      expect(@obj.complex_source.first.sequence_number).to be_empty
      expect(@obj.complex_source.first.start_page).to be_empty
      expect(@obj.complex_source.first.total_number_of_pages).to be_empty
      expect(@obj.complex_source.first.volume).to eq ['145']
    end

    it 'rejects source active triple with no values' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_source_attributes: [
          {
            title: ''
          }
        ]
      }
      @obj2 = ExampleWork2.new
      @obj2.attributes = {
        complex_source_attributes: [
          {
            sequence_number: nil
          }
        ]
      }
      expect(@obj.complex_source).to be_empty
      expect(@obj2.complex_source).to be_empty
    end
  end
end
