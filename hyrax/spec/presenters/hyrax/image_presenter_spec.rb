require 'rails_helper'

RSpec.describe Hyrax::ImagePresenter do
  let(:image) { create(:image, :open, :with_alternative_title, :with_description_abstract) }
  let(:solr_document) { SolrDocument.new(image.to_solr) }
  let(:host) { double(host: 'http://example.org') }
  let(:user) { nil }
  let(:presenter) { described_class.new(solr_document, Ability.new(user), host) }

  describe '#export_as_ttl' do
    subject { presenter.export_as_ttl }
    let(:export_regex) {
      [
          %r(<http://example.org/concern/images/#{image.id}> a),
          %r(<http://projecthydra.org/works/models#Work>),
          %r(<http://pcdm.org/models#Object>),
          %r(<http://purl.org/dc/terms/title> "Open Image";),
          %r(<http://purl.org/dc/terms/alternative> "Alternative-Title-123";),
          %r(<http://www.w3.org/ns/auth/acl#accessControl> <http://example.org/catalog/([a-f0-9\\-]*)+>;),
          %r(<info:fedora/fedora-system:def/model#hasModel> "Image" .)
      ]
    }
    let(:abstract_regex) { %r(<http://purl.org/dc/elements/1.1/description> "Abstract-Description-123";) }

    it 'exports' do
      export_regex.each do |regex|
        expect(subject).to match(regex)
      end
    end

    context 'anonymous user' do
      it { is_expected.not_to match(abstract_regex) }
    end

    context 'authenticated user' do
      let(:user) { create(:user, :nims_other) }
      it { is_expected.to match(abstract_regex) }
    end
  end

  describe '#export_as_nt' do
    subject { presenter.export_as_nt }
    let(:export_regex) {
      [
          %r(<http://example.org/concern/images/#{image.id}> <http://www.w3.org/ns/auth/acl#accessControl> <http://example.org/catalog/([a-f0-9\\-]*)+>),
          %r(<http://example.org/concern/images/#{image.id}> <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://projecthydra.org/works/models#Work>),
          %r(<http://example.org/concern/images/#{image.id}> <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://pcdm.org/models#Object>),
          %r(<http://example.org/concern/images/#{image.id}> <info:fedora/fedora-system:def/model#hasModel> "Image"),
          %r(<http://example.org/concern/images/#{image.id}> <http://purl.org/dc/terms/alternative> "Alternative-Title-123"),
          %r(<http://example.org/concern/images/#{image.id}> <http://purl.org/dc/terms/title> "Open Image")
      ]
    }
    let(:abstract_regex) { %r(<http://example.org/concern/images/#{image.id}> <http://purl.org/dc/elements/1.1/description> "Abstract-Description-123") }

    it 'exports' do
      export_regex.each do |regex|
        expect(subject).to match(regex)
      end
    end

    context 'anonymous user' do
      it { is_expected.not_to match(abstract_regex) }
    end

    context 'authenticated user' do
      let(:user) { create(:user, :nims_other) }
      it { is_expected.to match(abstract_regex) }
    end
  end

  describe '#export_as_jsonld' do
    subject { JSON.parse(presenter.export_as_jsonld) }
    # NB: it is important to use => rather than a colon: - otherwise the strings get symbolised

    it 'exports' do
      expect(subject["@context"]).to include(
                                         "pcdmterms" => "http://pcdm.org/models#",
                                         "worksterms" => "http://projecthydra.org/works/models#",
                                         "dc" => "http://purl.org/dc/terms/",
                                         "acl" => "http://www.w3.org/ns/auth/acl#",
                                         "system" => "info:fedora/fedora-system:",
                                         "model" => "system:def/model#"
                                     )
      expect(subject["@id"]).to eql "http://example.org/concern/images/#{image.id}"
      expect(subject["dc:title"]).to eql "Open Image"
      expect(subject["dc:alternative"]).to eql "Alternative-Title-123"
      expect(subject["model:hasModel"]).to eql "Image"
      expect(subject["acl:accessControl"]).to include("@id")
      expect(subject["@type"]).to match_array %w(pcdmterms:Object worksterms:Work)
    end

    context 'anonymous user' do
      it { is_expected.not_to include("dc11:description" => "Abstract-Description-123") }
    end

    context 'authenticated user' do
      let(:user) { create(:user, :nims_other) }
      it { is_expected.to include("dc11:description" => "Abstract-Description-123") }
    end
  end
end
