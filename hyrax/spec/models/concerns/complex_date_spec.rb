require 'rails_helper'

RSpec.describe ComplexDate do
  before do
    class ExampleWork < ActiveFedora::Base
      property :complex_date, predicate: ::RDF::Vocab::DC.date,
        class_name:"ComplexDate"
      accepts_nested_attributes_for :complex_date
    end
  end
  after do
    Object.send(:remove_const, :ExampleWork)
  end

  it 'has the correct uri' do
    @obj = ExampleWork.new
    @obj.attributes = {
      complex_date_attributes: [
        {
          date: '1978-10-06'
        }
      ]
    }
    expect(@obj.complex_date.first.id).to include('#date')
  end

  it 'creates a date active triple resource with all the attributes' do
    @obj = ExampleWork.new
    @obj.attributes = {
      complex_date_attributes: [
        {
          date: '1978-10-28',
          description: 'Some kind of a date',
        }
      ]
    }
    expect(@obj.complex_date.first).to be_kind_of ActiveTriples::Resource
    expect(@obj.complex_date.first.date).to eq ['1978-10-28']
    expect(@obj.complex_date.first.description).to eq ['Some kind of a date']
  end

  describe 'when reject_if is a symbol' do
    before do
      class ExampleWork2 < ExampleWork
        include ComplexValidation
        accepts_nested_attributes_for :complex_date, reject_if: :date_blank
      end
    end
    after do
      Object.send(:remove_const, :ExampleWork2)
    end

    it 'creates a date active triple resource with just the date' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_date_attributes: [
          {
            date: '1984-09-01'
          }
        ]
      }
      expect(@obj.complex_date.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_date.first.date).to eq ['1984-09-01']
      expect(@obj.complex_date.first.description).to be_empty
    end

    it 'rejects a date active triple with no date' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_date_attributes: [
          {
            description: 'Local date'
          }
        ]
      }
      expect(@obj.complex_date).to be_empty
    end
  end
end
