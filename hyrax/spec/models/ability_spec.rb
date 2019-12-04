require 'rails_helper'

RSpec.describe Ability do
  let(:ability) { Ability.new(user) }

  describe '#everyone_can_create_dataset' do
    subject { ability.can?(:create, ::Dataset) }

    context 'guest user' do
      let(:user) { build(:user, :guest) }
      it { is_expected.to be false }
    end

    context 'general user' do
      let(:user) { create(:user) }
      it { is_expected.to be true }
    end

    context 'admin user' do
      let(:user) { build(:user, :admin )}
      it { is_expected.to be true }
    end
  end

  describe '#everyone_can_create_publication' do
    subject { ability.can?(:create, ::Publication) }

    context 'guest user' do
      let(:user) { build(:user, :guest) }
      it { is_expected.to be false }
    end

    context 'general user' do
      let(:user) { create(:user) }
      it { is_expected.to be true }
    end

    context 'admin user' do
      let(:user) { build(:user, :admin )}
      it { is_expected.to be true }
    end
  end

  describe '#read_metadata' do
    let(:read_abstract) { ability.can?(:read_abstract, model) }
    let(:read_alternative_title) { ability.can?(:read_alternative_title, model) }
    let(:read_creator) { ability.can?(:read_creator, model) }
    let(:read_date) { ability.can?(:read_date, model) }
    let(:read_event) { ability.can?(:read_event, model) }
    let(:read_identifier) { ability.can?(:read_identifier, model) }
    let(:read_issue) { ability.can?(:read_issue, model) }
    let(:read_table_of_contents) { ability.can?(:read_table_of_contents, model) }
    let(:read_keyword) { ability.can?(:read_keyword, model) }
    let(:read_language) { ability.can?(:read_language, model) }
    let(:read_location) { ability.can?(:read_location, model) }
    let(:read_number_of_pages) { ability.can?(:read_number_of_pages, model) }
    let(:read_organization) { ability.can?(:read_organization, model) }
    let(:read_publisher) { ability.can?(:read_publisher, model) }
    let(:read_related) { ability.can?(:read_related, model) }
    let(:read_resource_type) { ability.can?(:read_resource_type, model) }
    let(:read_rights) { ability.can?(:read_rights, model) }
    let(:read_source) { ability.can?(:read_source, model) }
    let(:read_subject) { ability.can?(:read_subject, model) }
    let(:read_title) { ability.can?(:read_title, model) }
    let(:read_version) { ability.can?(:read_version, model) }

    context 'unauthenticated user' do
      let(:user) { build(:user, :guest) }

      context 'dataset' do
        let(:model) { ::Dataset}
        it { expect(read_abstract).to be false }
        it { expect(read_alternative_title).to be true }
        it { expect(read_creator).to be true }
        it { expect(read_date).to be true }
        it { expect(read_event).to be false }
        it { expect(read_identifier).to be true }
        it { expect(read_issue).to be false }
        it { expect(read_table_of_contents).to be false }
        it { expect(read_keyword).to be true }
        it { expect(read_language).to be true }
        it { expect(read_location).to be false }
        it { expect(read_number_of_pages).to be false }
        it { expect(read_organization).to be true }
        it { expect(read_publisher).to be true }
        it { expect(read_related).to be true }
        it { expect(read_resource_type).to be true }
        it { expect(read_rights).to be true }
        it { expect(read_source).to be true }
        it { expect(read_subject).to be true }
        it { expect(read_title).to be true }
        it { expect(read_version).to be true }
      end

      context 'image' do
        let(:model) { ::Image}
        it { expect(read_abstract).to be false }
        it { expect(read_alternative_title).to be true }
        it { expect(read_creator).to be true }
        it { expect(read_date).to be true }
        it { expect(read_event).to be false }
        it { expect(read_identifier).to be true }
        it { expect(read_issue).to be false }
        it { expect(read_table_of_contents).to be false }
        it { expect(read_keyword).to be true }
        it { expect(read_language).to be true }
        it { expect(read_location).to be false }
        it { expect(read_number_of_pages).to be false }
        it { expect(read_organization).to be false }
        it { expect(read_publisher).to be true }
        it { expect(read_related).to be false }
        it { expect(read_resource_type).to be true }
        it { expect(read_rights).to be true }
        it { expect(read_source).to be false }
        it { expect(read_subject).to be true }
        it { expect(read_title).to be true }
        it { expect(read_version).to be true }
      end

      context 'publication' do
        let(:model) { ::Publication}
        it { expect(read_abstract).to be false }
        it { expect(read_alternative_title).to be true }
        it { expect(read_creator).to be true }
        it { expect(read_date).to be true }
        it { expect(read_event).to be true }
        it { expect(read_identifier).to be true }
        it { expect(read_issue).to be true }
        it { expect(read_table_of_contents).to be true }
        it { expect(read_keyword).to be true }
        it { expect(read_language).to be true }
        it { expect(read_location).to be true }
        it { expect(read_number_of_pages).to be true }
        it { expect(read_organization).to be true }
        it { expect(read_publisher).to be true }
        it { expect(read_related).to be true }
        it { expect(read_resource_type).to be true }
        it { expect(read_rights).to be true }
        it { expect(read_source).to be true }
        it { expect(read_subject).to be true }
        it { expect(read_title).to be true }
        it { expect(read_version).to be true }
      end
    end

    context 'authenticated NIMS Researcher' do
      let(:user) { build(:user, :nims_researcher) }

      context 'dataset' do
        let(:model) { ::Dataset}
        it { expect(read_abstract).to be true }
        it { expect(read_alternative_title).to be true }
        it { expect(read_creator).to be true }
        it { expect(read_date).to be true }
        it { expect(read_event).to be false }
        it { expect(read_identifier).to be true }
        it { expect(read_issue).to be false }
        it { expect(read_table_of_contents).to be false }
        it { expect(read_keyword).to be true }
        it { expect(read_language).to be true }
        it { expect(read_location).to be false }
        it { expect(read_number_of_pages).to be false }
        it { expect(read_organization).to be true }
        it { expect(read_publisher).to be true }
        it { expect(read_related).to be true }
        it { expect(read_resource_type).to be true }
        it { expect(read_rights).to be true }
        it { expect(read_source).to be true }
        it { expect(read_subject).to be true }
        it { expect(read_title).to be true }
        it { expect(read_version).to be true }
      end

      context 'image' do
        let(:model) { ::Image}
        it { expect(read_abstract).to be true }
        it { expect(read_alternative_title).to be true }
        it { expect(read_creator).to be true }
        it { expect(read_date).to be true }
        it { expect(read_event).to be false }
        it { expect(read_identifier).to be true }
        it { expect(read_issue).to be false }
        it { expect(read_table_of_contents).to be false }
        it { expect(read_keyword).to be true }
        it { expect(read_language).to be true }
        it { expect(read_location).to be false }
        it { expect(read_number_of_pages).to be false }
        it { expect(read_organization).to be false }
        it { expect(read_publisher).to be true }
        it { expect(read_related).to be false }
        it { expect(read_resource_type).to be true }
        it { expect(read_rights).to be true }
        it { expect(read_source).to be false }
        it { expect(read_subject).to be true }
        it { expect(read_title).to be true }
        it { expect(read_version).to be true }
      end

      context 'publication' do
        let(:model) { ::Publication}
        it { expect(read_abstract).to be true }
        it { expect(read_alternative_title).to be true }
        it { expect(read_creator).to be true }
        it { expect(read_date).to be true }
        it { expect(read_event).to be true }
        it { expect(read_identifier).to be true }
        it { expect(read_issue).to be true }
        it { expect(read_table_of_contents).to be true }
        it { expect(read_keyword).to be true }
        it { expect(read_language).to be true }
        it { expect(read_location).to be true }
        it { expect(read_number_of_pages).to be true }
        it { expect(read_organization).to be true }
        it { expect(read_publisher).to be true }
        it { expect(read_related).to be true }
        it { expect(read_resource_type).to be true }
        it { expect(read_rights).to be true }
        it { expect(read_source).to be true }
        it { expect(read_subject).to be true }
        it { expect(read_title).to be true }
        it { expect(read_version).to be true }
      end
    end
  end
end
