require 'rails_helper'

RSpec.describe Hyrax::CitationsBehaviors::PublicationBehavior, :type => :helper do

  describe '#setup_doi' do
    subject { helper.setup_doi(build(:publication, :with_doi)) }
    skip 'work in progress'
     # it { is_expected.to eql('fooo') }
  end

  describe '#setup_pub_date' do
    subject { helper.setup_pub_date(build(:publication, :with_date)) }
    skip 'work in progress'
    # it { is_expected.to eql('fooo') }
  end

  describe '#setup_pub_place' do
    subject { helper.setup_pub_place(build(:publication, :with_place)) }
    it { is_expected.to eql('221B Baker Street') }
  end

  describe '#setup_pub_publisher' do
    subject { helper.setup_pub_publisher(build(:publication, :with_publisher)) }
    it { is_expected.to eql('Foo Publisher') }
  end

  it 'has no singleton methods' do
    expect(subject.singleton_methods).to be_empty
  end
end
