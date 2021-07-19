require 'rails_helper'

RSpec.describe Hyrax::PublicationForm do
  it { expect(described_class).to be < Hyrax::Forms::WorkForm }

  describe '#metadata_tab_terms' do
    let(:model) { build(:dataset) }
    let(:ability) { Ability.new(create(:user)) }
    let(:controller) { nil } # doesn't require a value for these tests
    let(:form) { described_class.new(model, ability, controller) }

    subject { form.metadata_tab_terms }
    it { is_expected.to include(:first_published_url, :supervisor_approval, :title, :alternative_title,
      :language, :resource_type, :description,
      :keyword_ordered, :specimen_set_ordered, :complex_person, :complex_identifier,
      :manuscript_type, :publisher, :specimen_set_ordered,
      :managing_organization_ordered,
      :date_published, :rights_statement, :licensed_date, :complex_identifier, :complex_source,
      :complex_version, :complex_relation, :complex_date, :complex_event,
      :custom_property) }
  end

  describe '#build_permitted_params' do
    subject { described_class.build_permitted_params }

    it { is_expected.to include(:member_of_collection_ids, :find_child_work) }

    context 'permitted params' do
      it do
        expect(described_class).to receive(:permitted_date_params).at_least(:once).and_call_original
        expect(described_class).to receive(:permitted_identifier_params).at_least(:once).and_call_original
        expect(described_class).to receive(:permitted_person_params).at_least(:once).and_call_original
        expect(described_class).to receive(:permitted_relation_params).at_least(:once).and_call_original
        expect(described_class).to receive(:permitted_version_params).at_least(:once).and_call_original
        expect(described_class).to receive(:permitted_event_params).at_least(:once).and_call_original
        expect(described_class).to receive(:permitted_source_params).at_least(:once).and_call_original
        expect(described_class).to receive(:permitted_custom_property_params).at_least(:once).and_call_original
        subject
      end
    end
  end
end
