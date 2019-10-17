require 'rails_helper'

RSpec.describe Hyrax::CitationsBehaviors::NameBehavior, :type => :helper do
  let(:publication) { build(:publication, :with_people) }
  let(:presenter) { Hyrax::WorkPresenter.new(SolrDocument.new(publication.to_solr),  Ability.new(nil)) }

  describe '#author_list' do
    subject { helper.author_list(presenter) }
    it { is_expected.to match_array(['Foo Bar', 'Small Buz']) }
  end

  describe '#all_authors' do
    subject { helper.all_authors(presenter) }
    it { is_expected.to match_array(['Foo Bar', 'Small Buz']) }
  end

  describe '#given_name_first' do
    context 'without a comma' do
      subject { helper.given_name_first('First LAST') }
      it { is_expected.to eql('First LAST') }
    end

    context 'with a comma' do
      subject { helper.given_name_first('LAST, First') }
      it { is_expected.to eql('First LAST') }
    end
  end

  describe '#surname_first' do
    context 'without a comma' do
      subject { helper.surname_first('First LAST') }
      it { is_expected.to eql('LAST, First') }
    end

    context 'with a comma' do
      subject { helper.surname_first('LAST, First') }
      it { is_expected.to eql('LAST, First') }
    end

    context 'without a surname' do
      subject { helper.surname_first('Alice') }
      it { is_expected.to eql('Alice') }
    end
  end

  describe '#abbreviate_name' do
    context 'without a comma' do
      subject { helper.abbreviate_name('First LAST') }
      it { is_expected.to eql('LAST, F.') }
    end

    context 'with a comma' do
      subject { helper.abbreviate_name('LAST, First') }
      it { is_expected.to eql('LAST, F.') }
    end
  end

  it 'has no singleton methods' do
    expect(subject.singleton_methods).to be_empty
  end
end