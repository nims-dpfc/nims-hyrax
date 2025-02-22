require 'rails_helper'

RSpec.describe Hyrax::DatasetForm do
  it { expect(described_class).to be < Hyrax::Forms::WorkForm }

  describe 'instance methods' do
    let(:model) { build(:dataset) }
    let(:ability) { Ability.new(create(:user)) }
    let(:controller) { nil } # doesn't require a value for these tests
    let(:form) { described_class.new(model, ability, controller) }

    describe '#metadata_tab_terms' do
      subject { form.metadata_tab_terms }
      it { is_expected.to include(
        :managing_organization_ordered,
        :first_published_url,
        :title, :alternate_title, :resource_type, :data_origin, :description,
        :keyword_ordered, :specimen_set_ordered,
        :material_type, :publisher, :date_published, :rights_statement,
        :licensed_date, :license_description,
        :complex_person, :complex_contact_agent, :complex_source,
        :manuscript_type,
        :complex_event, :language, :complex_identifier,
        :complex_version,
        :complex_funding_reference, :complex_relation, :custom_property
        ) }
    end

    describe '#method_tab_terms' do
      subject { form.method_tab_terms }
      it { is_expected.to include(:characterization_methods, :properties_addressed, :synthesis_and_processing) }
      it { is_expected.to include(:complex_feature) }
      it { is_expected.to include(:complex_software) }
      it { is_expected.to include(:complex_computational_method) }
      it { is_expected.to include(:complex_experimental_method) }
    end

    describe '#instrument_tab_terms' do
      subject { form.instrument_tab_terms }
      it { is_expected.to include(:complex_instrument) }
      it { is_expected.to include(:complex_instrument_operator) }
    end

    describe '#specimen_tab_terms' do
      subject { form.specimen_tab_terms }
      it { is_expected.to include(:complex_specimen_type) }
      it { is_expected.to include(:complex_chemical_composition) }
      it { is_expected.to include(:complex_structural_feature) }
      it { is_expected.to include(:complex_crystallographic_structure) }
    end
  end

  describe '#build_permitted_params' do
    subject { described_class.build_permitted_params }

    it { is_expected.to include(:find_child_work) }

    context 'permitted params' do
      it do
        expect(described_class).to receive(:permitted_identifier_params).at_least(:once).and_call_original
        expect(described_class).to receive(:permitted_instrument_params).at_least(:once).and_call_original
        expect(described_class).to receive(:permitted_instrument_operator_params).at_least(:once).and_call_original
        expect(described_class).to receive(:permitted_person_params).at_least(:once).and_call_original
        expect(described_class).to receive(:permitted_organization_params).at_least(:once).and_call_original
        expect(described_class).to receive(:permitted_relation_params).at_least(:once).and_call_original
        expect(described_class).to receive(:permitted_specimen_type_params).at_least(:once).and_call_original
        expect(described_class).to receive(:permitted_version_params).at_least(:once).and_call_original
        expect(described_class).to receive(:permitted_event_params).at_least(:once).and_call_original
        expect(described_class).to receive(:permitted_source_params).at_least(:once).and_call_original
        expect(described_class).to receive(:permitted_custom_property_params).at_least(:once).and_call_original
        expect(described_class).to receive(:permitted_fundref_params).at_least(:once).and_call_original
        expect(described_class).to receive(:permitted_contact_agent_params).at_least(:once).and_call_original
        expect(described_class).to receive(:permitted_chemical_composition_params).at_least(:once).and_call_original
        expect(described_class).to receive(:permitted_structural_feature_params).at_least(:once).and_call_original
        expect(described_class).to receive(:permitted_crystallographic_structure_params).at_least(:once).and_call_original
        expect(described_class).to receive(:permitted_feature_params).at_least(:once).and_call_original
        expect(described_class).to receive(:permitted_software_params).at_least(:once).and_call_original
        expect(described_class).to receive(:permitted_computational_method_params).at_least(:once).and_call_original
        expect(described_class).to receive(:permitted_experimental_method_params).at_least(:once).and_call_original
        subject
      end
    end
  end
end
