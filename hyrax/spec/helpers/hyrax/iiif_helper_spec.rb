require 'rails_helper'

RSpec.describe Hyrax::IiifHelper, :type => :helper do
  let(:publication) { build(:publication) }
  let(:mock_solr_doc) { instance_double(SolrDocument, to_model: publication) } # a bit of a hack to make the routing work in tests
  let(:presenter) { Hyrax::WorkPresenter.new(mock_solr_doc,  Ability.new(nil)) }

  describe '#iiif_viewer_display' do
    subject { helper.iiif_viewer_display(presenter) }
    it { is_expected.to start_with('<div class="viewer-wrapper">') }
    it { is_expected.to include('<iframe') }
    it { is_expected.to include('src="http://test.host/uv/uv.html#?manifest=http://test.host/concern/publications/%23%5BInstanceDouble(SolrDocument)%20(anonymous)%5D/manifest&config=http://test.host/uv/uv-config.json') }
    it { is_expected.to include('allowfullscreen="true"') }
    it { is_expected.to include('frameborder="0"') }
    it { is_expected.to include('></iframe>') }
    it { is_expected.to include('</div>') }
  end

  describe '#iiif_viewer_display_partial' do
    subject { helper.iiif_viewer_display_partial(presenter) }
    it { is_expected.to eql('hyrax/base/iiif_viewers/universal_viewer')}
  end

  describe '#universal_viewer_base_url' do
    subject { helper.universal_viewer_base_url }
    it { is_expected.to eql('http://test.host/uv/uv.html')}
  end

  describe '#universal_viewer_config_url' do
    subject { helper.universal_viewer_config_url }
    it { is_expected.to eql('http://test.host/uv/uv-config.json')}
  end

  it 'has no singleton methods' do
    expect(subject.singleton_methods).to be_empty
  end
end
