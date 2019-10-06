require 'rails_helper'

RSpec.describe ComplexHistory do
  before do
    class ExampleWork < ActiveFedora::Base
      property :complex_history, predicate: ::RDF::Vocab::NimsRdp['history'],
        class_name:"ComplexHistory"
      accepts_nested_attributes_for :complex_history
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
          .new({ complex_history_attributes: [{ upstream: 'Upstream 1' }]})
          .complex_history
          .first
          .upstream
    end
    it { is_expected.to eq ['Upstream 1'] }
  end

  it 'has the correct uri' do
    @obj = ExampleWork.new
    @obj.attributes = {
      complex_history_attributes: [{
        complex_event_date_attributes: [{
          date: ['2018-01-28'],
          description: 'Event',
        }],
        complex_operator_attributes: [{
          name: ['operator 1'],
          role: ['Operator']
        }],
        upstream: 'Some event before',
        downstream: 'Some event after'
      }]
    }
    expect(@obj.complex_history.first.id).to include('#history')
  end

  it 'creates a history active triple resource with all the attributes' do
    @obj = ExampleWork.new
    @obj.attributes = {
      complex_history_attributes: [{
        complex_event_date_attributes: [{
          date: ['2018-01-28'],
          description: 'Event',
        }],
        complex_operator_attributes: [{
          name: ['operator 1'],
          role: ['Operator']
        }],
        upstream: 'An upstream event',
        downstream: 'A downstream event'
      }]
    }
    expect(@obj.complex_history.first).to be_kind_of ActiveTriples::Resource
    expect(@obj.complex_history.first.upstream).to eq ['An upstream event']
    expect(@obj.complex_history.first.downstream).to eq ['A downstream event']
    expect(@obj.complex_history.first.complex_event_date.first).to be_kind_of ActiveTriples::Resource
    expect(@obj.complex_history.first.complex_event_date.first.date).to eq ['2018-01-28']
    expect(@obj.complex_history.first.complex_event_date.first.description).to eq ['Event']
    expect(@obj.complex_history.first.complex_operator.first).to be_kind_of ActiveTriples::Resource
    expect(@obj.complex_history.first.complex_operator.first.name).to eq ['operator 1']
    expect(@obj.complex_history.first.complex_operator.first.role).to eq ['Operator']
  end

  describe "when reject_if is a symbol" do
    before do
      class ExampleWork2 < ExampleWork
        include ComplexValidation
        accepts_nested_attributes_for :complex_history, reject_if: :history_blank
      end
    end
    after do
      Object.send(:remove_const, :ExampleWork2)
    end

    it 'creates a history active triple resource with event date, operator name, upstream and downstream events' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_history_attributes: [{
          complex_event_date_attributes: [{
            date: ['2018-01-28']
          }],
          complex_operator_attributes: [{
            name: ['operator 1']
          }],
          upstream: 'An upstream event',
          downstream: 'A downstream event'
        }]
      }
      expect(@obj.complex_history.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_history.first.complex_event_date.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_history.first.complex_event_date.first.date).to eq ['2018-01-28']
      expect(@obj.complex_history.first.complex_event_date.first.description).to be_empty
      expect(@obj.complex_history.first.complex_operator.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_history.first.complex_operator.first.name).to eq ['operator 1']
      expect(@obj.complex_history.first.complex_operator.first.role).to be_empty
      expect(@obj.complex_history.first.upstream).to eq ['An upstream event']
      expect(@obj.complex_history.first.downstream).to eq ['A downstream event']
    end

    it 'creates a history active triple resource with only event date' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_history_attributes: [{
          complex_event_date_attributes: [{
            date: ['2018-01-28']
          }]
        }]
      }
      expect(@obj.complex_history.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_history.first.complex_event_date.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_history.first.complex_event_date.first.date).to eq ['2018-01-28']
      expect(@obj.complex_history.first.complex_event_date.first.description).to be_empty
      expect(@obj.complex_history.first.complex_operator).to be_empty
      expect(@obj.complex_history.first.upstream).to be_empty
      expect(@obj.complex_history.first.downstream).to be_empty
    end

    it 'creates a history active triple resource with only operator name' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_history_attributes: [{
          complex_operator_attributes: [{
            name: ['operator 1']
          }]
        }]
      }
      expect(@obj.complex_history.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_history.first.complex_event_date).to be_empty
      expect(@obj.complex_history.first.complex_operator.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_history.first.complex_operator.first.name).to eq ['operator 1']
      expect(@obj.complex_history.first.complex_operator.first.role).to be_empty
      expect(@obj.complex_history.first.upstream).to be_empty
      expect(@obj.complex_history.first.downstream).to be_empty
    end

    it 'creates a history active triple resource with only upstream event' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_history_attributes: [{
          upstream: 'An upstream event'
        }]
      }
      expect(@obj.complex_history.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_history.first.complex_event_date).to be_empty
      expect(@obj.complex_history.first.complex_operator).to be_empty
      expect(@obj.complex_history.first.upstream).to eq ['An upstream event']
      expect(@obj.complex_history.first.downstream).to be_empty
    end

    it 'creates a history active triple resource with only downstream event' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_history_attributes: [{
          downstream: 'A downstream event'
        }]
      }
      expect(@obj.complex_history.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_history.first.complex_event_date).to be_empty
      expect(@obj.complex_history.first.complex_operator).to be_empty
      expect(@obj.complex_history.first.upstream).to be_empty
      expect(@obj.complex_history.first.downstream).to eq ['A downstream event']
    end

    it 'rejects an history active triple with no data' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_history_attributes: [{
          complex_operator_attributes: [{
            name: '',
            role: ['Operator']
          }],
          downstream: nil
        }]
      }
      expect(@obj.complex_history).to be_empty
    end

  end
end
