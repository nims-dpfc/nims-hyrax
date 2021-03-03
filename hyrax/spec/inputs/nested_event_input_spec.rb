require 'rails_helper'

RSpec.describe NestedEventInput, type: :input do
  it { expect(described_class).to be < NestedAttributesInput }

  let(:publication) { build(:publication, :with_complex_event) }
  let(:object) { double(required?: true, model: publication) }
  let(:builder) { SimpleForm::FormBuilder.new(:publication, object, view, {}) }
  let(:input) { described_class.new(builder, :complex_event, nil, :multi_value, {}) }
  let(:value) { publication.complex_event.first }
  let(:index) { 0 }
  let(:options) { {} }
  let(:html) { input.send(:build_components, :complex_event, value, index, options) }

  subject { Capybara.string(html) }

  it 'generates the correct fields' do
    is_expected.to have_field('publication_complex_event_attributes_0_title', type: :text, with: 'Event-Title-123')
    is_expected.to have_field('publication_complex_event_attributes_0_place', type: :text, with: 'New Scotland Yard')
    is_expected.to have_field('publication_complex_event_attributes_0_start_date', type: :text, with: '2018-12-25')
    is_expected.to have_field('publication_complex_event_attributes_0_end_date', type: :text, with: '2019-01-01')
    is_expected.to have_field('publication_complex_event_attributes_0_invitation_status', type: :checkbox, with: '1')
  end
end
