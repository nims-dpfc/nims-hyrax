require 'rails_helper'

RSpec.describe Hyrax::DatasetPresenter do
  let(:dataset) { create(:dataset, :open, :with_alternative_title, :with_description_abstract) }
  let(:solr_document) { SolrDocument.new(dataset.to_solr) }
  let(:host) { double(host: 'http://example.org/') }

  let(:presenter) { described_class.new(solr_document, Ability.new(user), host) }

  let(:ttl_regex) {
    [
      %r(<http://example.org//concern/datasets/#{dataset.id}> a),
      %r(<http://projecthydra.org/works/models#Work>),
      %r(<http://pcdm.org/models#Object>),
      %r(<http://purl.org/dc/terms/title> "Open Dataset";),
      %r(<http://purl.org/dc/terms/alternative> "Alternative-Title-123";),
      %r(<http://www.w3.org/ns/auth/acl#accessControl> <http://example.org//catalog/([a-f0-9\\-]*)+>;),
      %r(<info:fedora/fedora-system:def/model#hasModel> "Dataset" .)
    ]
  }
  let(:ttl_regex_abstract) { %r(<http://purl.org/dc/elements/1.1/description> "Abstract-Description-123";) }

  describe '#export_as_ttl' do
    subject { presenter.export_as_ttl }
    let(:user) { nil }
    it 'generates ttl' do
      ttl_regex.each do |regex|
        expect(subject).to match(regex)
      end
    end

    context 'anonymous user' do
      it { is_expected.not_to match(ttl_regex_abstract) }
    end

    context 'authenticated user' do
      let(:user) { create(:user, :nims_other) }
      it { is_expected.to match(ttl_regex_abstract) }
    end
  end






  # # let(:graph) { Hyrax::GraphExporter.new(solr_document, host).fetch }
  #
  # let(:ttl) { graph.dump(:ttl) }
  # let(:dmp) {  graph.each_statement {|s| puts "SUBJ: #{s.subject}\tPRED:#{s.predicate}\tOBJ: #{s.object}" } }
  #
  # # let(:replacer) { ->(id, _graph) {
  # #     puts "id: #{id.inspect}\n _graph: #{_graph.inspect}"
  # #   }
  # # }
  #
  #
  # #let(:connection) { Hyrax::CleanConnection.new(ActiveFedora.fedora.connection) }
  # #let(:clean_graph_repository) { Hydra::ContentNegotiation::CleanGraphRepository.new(connection, replacer) }
  # #let(:clean_graph) { clean_graph_repository.find(solr_document.id) }
  #
  # let(:clean_graph) {
  #   RDF::Graph.new.insert(*graph.each_statement.to_a.reject { |statement| statement.predicate == 'http://purl.org/dc/elements/1.1/description' })
  # }
  #
  # let(:clean_ttl) { clean_graph.dump(:ttl) }
  # let(:clean_dmp) {  clean_graph.each_statement {|s| puts "SUBJ: #{s.subject}\tPRED:#{s.predicate}\tOBJ: #{s.object}" } }
  #
  #
  # it "filters abstract for anonymous users" do
  #   # puts graph.inspect
  #   require 'byebug'
  #   byebug
  #
  #
  #
  # end
end
