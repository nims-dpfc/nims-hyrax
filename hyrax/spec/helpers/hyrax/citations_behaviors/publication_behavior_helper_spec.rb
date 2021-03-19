require 'rails_helper'

RSpec.describe Hyrax::CitationsBehaviors::PublicationBehavior, :type => :helper do
  let(:presenter) { Hyrax::PublicationPresenter.new(SolrDocument.new(publication.to_solr),  Ability.new(nil)) }

  describe '#setup_doi' do
    let(:publication) { build(:publication, :with_complex_identifier) }
    subject { helper.setup_doi(presenter) }

    context 'valid solr json' do
      it { is_expected.to eql('10.0.1111. 10.0.2222') }
    end

    context 'invalid solr json' do
      before { allow(presenter).to receive(:complex_identifier) { 'some illegal solr json' } }
      it { is_expected.to be_nil }
    end
  end

  describe '#setup_pub_date' do
    let(:publication) { build(:publication, :with_date_published) }
    subject { helper.setup_pub_date(presenter) }
    it { is_expected.to eql('0528') }
  end

  describe '#setup_pub_place' do
    context 'with publication' do
      let(:publication) { build(:publication, :with_place) }
      subject { helper.setup_pub_place(presenter) }
      it { is_expected.to eql('221B Baker Street Place') }
    end
    context 'with dataset' do
      let(:publication) { build(:dataset) }
      subject { helper.setup_pub_place(presenter) }
      it { is_expected.to eql('') }
    end
  end

  describe '#setup_pub_publisher' do
    let(:publication) { build(:publication, :with_publisher) }
    subject { helper.setup_pub_publisher(presenter) }
    it { is_expected.to eql('Publisher-123') }
  end

  describe '#setup_pub_info' do
    let(:publication) { build(:publication, :with_complex_identifier, :with_date_published, :with_place, :with_publisher) }
    subject { helper.setup_pub_info(presenter, include_date) }

    context 'without date' do
      let(:include_date) { false }
      it { is_expected.to eql('221B Baker Street Place: Publisher-123. 10.0.1111. 10.0.2222') }
    end

    context 'with date' do
      let(:include_date) { true }
      it { is_expected.to eql('221B Baker Street Place: Publisher-123, 0528. 10.0.1111. 10.0.2222') }
    end
  end

  it 'has no singleton methods' do
    expect(subject.singleton_methods).to be_empty
  end

  describe '#setup_pub_source' do
    let(:publication) { build(:publication, :with_complex_source) }
    subject { helper.setup_pub_source(presenter) }
    it { is_expected.to eql('Test journal. 3, no. 34. 1.2.2.') }
  end

  describe '#setup_pub_page' do
    let(:publication) { build(:publication, :with_complex_source) }
    subject { helper.setup_pub_page(presenter) }
    it { is_expected.to eql('4-12.') }
  end

  describe '#setup_pub_citation_info' do
    let(:publication) { build(:publication, :with_complex_source) }
    subject { helper.setup_pub_citation_info(presenter) }
    it { is_expected.to eql({title: 'Test journal', volume: '3', issue: '34', start_page: '4', end_page: '12'}) }
  end
end
