require 'rails_helper'

RSpec.describe ComplexEvent do
  before do
    class ExampleWork < ActiveFedora::Base
      property :complex_event, predicate: ::RDF::Vocab::ESciDocPublication.Event, class_name:"ComplexEvent"
      accepts_nested_attributes_for :complex_event
    end
  end
  after do
    Object.send(:remove_const, :ExampleWork)
  end

  it 'has the correct uri' do
    @obj = ExampleWork.new
    @obj.attributes = {
      complex_event_attributes: [
        {
          title: "A Title"
        }
      ]
    }
    expect(@obj.complex_event.first.id).to include('#event')
  end

  it 'creates an event active triple resource with an id and all properties' do
    @obj = ExampleWork.new
    @obj.attributes = {
      complex_event_attributes: [
        {
          end_date: '2019-01-01',
          invitation_status: true,
          place: '221B Baker Street',
          start_date: '2018-12-25',
          title: 'A Title',
        }
      ]
    }
    expect(@obj.complex_event.first).to be_kind_of ActiveTriples::Resource
    expect(@obj.complex_event.first.end_date).to eq ['2019-01-01']
    expect(@obj.complex_event.first.invitation_status).to eq [true]
    expect(@obj.complex_event.first.place).to eq ['221B Baker Street']
    expect(@obj.complex_event.first.start_date).to eq ['2018-12-25']
    expect(@obj.complex_title.first.title).to eq ['A Title']
  end
end
