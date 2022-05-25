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
      it { is_expected.to include(:title, :alternative_title, :data_origin, :description,
        :keyword_ordered, :specimen_set_ordered, :complex_person, :complex_identifier, :complex_source,
        :publisher, :resource_type, :licensed_date, :material_type,
        :first_published_url, :managing_organization_ordered, :complex_event, :complex_version,
        :complex_funding_reference, :complex_relation, :custom_property, :language, :date_published, :complex_date,
        :rights_statement) }
    end

    describe '#method_tab_terms' do
      subject { form.method_tab_terms }
      it { is_expected.to include(:characterization_methods, :computational_methods, :properties_addressed, :synthesis_and_processing) }
    end

    describe '#instrument_tab_terms' do
      subject { form.instrument_tab_terms }
      it { is_expected.to include(:complex_instrument) }
    end

    describe '#specimen_tab_terms' do
      subject { form.specimen_tab_terms }
      it { is_expected.to include(:complex_specimen_type) }
    end
  end

  describe '#build_permitted_params' do
    subject { described_class.build_permitted_params }

    it { is_expected.to include(:member_of_collection_ids, :find_child_work) }

    context 'permitted params' do
      it do
        expect(described_class).to receive(:permitted_date_params).at_least(:once).and_call_original
        expect(described_class).to receive(:permitted_identifier_params).at_least(:once).and_call_original
        expect(described_class).to receive(:permitted_instrument_params).at_least(:once).and_call_original
        expect(described_class).to receive(:permitted_person_params).at_least(:once).and_call_original
        expect(described_class).to receive(:permitted_organization_params).at_least(:once).and_call_original
        expect(described_class).to receive(:permitted_relation_params).at_least(:once).and_call_original
        expect(described_class).to receive(:permitted_specimen_type_params).at_least(:once).and_call_original
        expect(described_class).to receive(:permitted_version_params).at_least(:once).and_call_original
        expect(described_class).to receive(:permitted_event_params).at_least(:once).and_call_original
        expect(described_class).to receive(:permitted_source_params).at_least(:once).and_call_original
        expect(described_class).to receive(:permitted_custom_property_params).at_least(:once).and_call_original
        expect(described_class).to receive(:permitted_fundref_params).at_least(:once).and_call_original
        subject
      end
    end
  end
end
