require 'rails_helper'

RSpec.describe NestedContactAgentInput, type: :input do
  it { expect(described_class).to be < NestedAttributesInput }


  subject { Capybara.string(html) }

  let(:dataset) { build(:dataset, :with_complex_contact_agent) }
  let(:object) { double(required?: true, model: dataset) }
  let(:builder) { SimpleForm::FormBuilder.new(:dataset, object, view, {}) }
  let(:input) { described_class.new(builder, :complex_contact_agent, nil, :multi_value, {}) }
  let(:value) { dataset.complex_contact_agent.first }
  let(:index) { 0 }
  let(:options) { {} }
  let(:html) { input.send(:build_components, :complex_contact_agent, value, index, options) }

  it 'generates the correct fields' do
    is_expected.to have_field('dataset_complex_contact_agent_attributes_0_name', type: :text, with: 'Kosuke Tanabe')
    is_expected.to have_field('dataset_complex_contact_agent_attributes_0_email', type: :text, with: 'tanabe@example.jp')
    is_expected.to have_field('dataset_complex_contact_agent_attributes_0_organization', type: :text, with: "NIMS")
    is_expected.to have_field('dataset_complex_contact_agent_attributes_0_department', type: :text, with: "DPFC")
  end

end
