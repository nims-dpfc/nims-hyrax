require 'rails_helper'
require 'securerandom'

RSpec.describe Hyrax::PublicationPresenter do
  let(:publication) { create(:publication, :open, :with_alternative_title, :with_description_abstract, :with_supervisor_approval, depositor: 'depositor') }
  let(:solr_document) { SolrDocument.new(publication.to_solr) }
  let(:host) { double(host: 'http://example.org') }
  let(:user) { nil }
  let(:presenter) { described_class.new(solr_document, Ability.new(user), host) }

  describe '#export_as_ttl' do
    subject { presenter.export_as_ttl }
    let(:export_regex) {
      [
          %r(<http://example.org/concern/publications/#{publication.id}> a),
          %r(<http://projecthydra.org/works/models#Work>),
          %r(<http://pcdm.org/models#Object>),
          %r(<http://purl.org/dc/terms/title> "Open Publication";),
          %r(<http://purl.org/dc/terms/alternative> "Alternative-Title-123";),
          %r(<http://www.w3.org/ns/auth/acl#accessControl> <http://example.org/catalog/([a-f0-9\\-]*)+>;),
          %r(<info:fedora/fedora-system:def/model#hasModel> "Publication" .)
      ]
    }
    let(:abstract_regex) { %r(<http://purl.org/dc/elements/1.1/description> "Abstract-Description-123";) }
    let(:supervisor_regex) { %r(<http://www.nims.go.jp/vocabs/ngdr/supervisor-approval> "Professor-Supervisor-Approval";) }
    let(:depositor_regex) { %r(<http://example.org/concern/publications/#{publication.id}> <http://id.loc.gov/vocabulary/relators/dpt> "depositor") }

    it 'exports' do
      export_regex.each do |regex|
        expect(subject).to match(regex)
      end
    end

    context 'anonymous user' do
      it { is_expected.not_to match(abstract_regex) }
      it { is_expected.not_to match(supervisor_regex) }
      it { is_expected.not_to match(depositor_regex) }
    end

    context 'authenticated user' do
      let(:user) { create(:user, :nims_other, id: SecureRandom.hex(10)) }
      it { is_expected.not_to match(abstract_regex) }
      it { is_expected.not_to match(supervisor_regex) }
      it { is_expected.not_to match(depositor_regex) }
    end
  end

  describe '#export_as_nt' do
    subject { presenter.export_as_nt }
    let(:export_regex) {
      [
          %r(<http://example.org/concern/publications/#{publication.id}> <http://www.w3.org/ns/auth/acl#accessControl> <http://example.org/catalog/([a-f0-9\\-]*)+>),
          %r(<http://example.org/concern/publications/#{publication.id}> <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://projecthydra.org/works/models#Work>),
          %r(<http://example.org/concern/publications/#{publication.id}> <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://pcdm.org/models#Object>),
          %r(<http://example.org/concern/publications/#{publication.id}> <info:fedora/fedora-system:def/model#hasModel> "Publication"),
          %r(<http://example.org/concern/publications/#{publication.id}> <http://purl.org/dc/terms/alternative> "Alternative-Title-123"),
          %r(<http://example.org/concern/publications/#{publication.id}> <http://purl.org/dc/terms/title> "Open Publication")
      ]
    }
    let(:abstract_regex) { %r(<http://example.org/concern/publications/#{publication.id}> <http://purl.org/dc/elements/1.1/description> "Abstract-Description-123") }
    let(:supervisor_regex) { %r(<http://example.org/concern/publications/#{publication.id}> <http://www.nims.go.jp/vocabs/ngdr/supervisor-approval> "Professor-Supervisor-Approval") }
    let(:depositor_regex) { %r(<http://example.org/concern/publications/#{publication.id}> <http://id.loc.gov/vocabulary/relators/dpt> "depositor") }

    it 'exports' do
      export_regex.each do |regex|
        expect(subject).to match(regex)
      end
    end

    context 'anonymous user' do
      it { is_expected.not_to match(abstract_regex) }
      it { is_expected.not_to match(supervisor_regex) }
      it { is_expected.not_to match(depositor_regex) }
    end

    context 'authenticated user' do
      let(:user) { create(:user, :nims_other, id: SecureRandom.hex(10)) }
      it { is_expected.not_to match(abstract_regex) }
      it { is_expected.not_to match(supervisor_regex) }
      it { is_expected.not_to match(depositor_regex) }
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
      expect(subject["@id"]).to eql "http://example.org/concern/publications/#{publication.id}"
      expect(subject["dc:title"]).to eql "Open Publication"
      expect(subject["dc:alternative"]).to eql "Alternative-Title-123"
      expect(subject["model:hasModel"]).to eql "Publication"
      expect(subject["acl:accessControl"]).to include("@id")
      expect(subject["@type"]).to match_array %w(pcdm:Object worksterms:Work)
    end

    context 'anonymous user' do
      it { is_expected.not_to include("dc11:description" => "Abstract-Description-123") }
      it { is_expected.not_to include("nimsrdp:supervisor-approval" => "Professor-Supervisor-Approval") }
      it { is_expected.not_to include("marcrelators:dpt" => "depositor") }
    end

    context 'authenticated user' do
      let(:user) { create(:user, :nims_other, id: SecureRandom.hex(10)) }
      it { is_expected.not_to include("dc11:description" => "Abstract-Description-123") }
      it { is_expected.not_to include("nimsrdp:supervisor-approval" => "Professor-Supervisor-Approval") }
      it { is_expected.not_to include("marcrelators:dpt" => "depositor") }
    end
  end
end
