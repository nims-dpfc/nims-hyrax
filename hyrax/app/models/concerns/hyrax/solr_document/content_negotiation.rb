module Hyrax
  module SolrDocument
    module ContentNegotiation
      include FilteredGraph
      def self.extended(document)
        document.will_export_as(:nt, "application/n-triples")
        document.will_export_as(:jsonld, "application/ld+json")
        document.will_export_as(:ttl, "text/turtle")
      end

      def export_as_nt
        graph.dump(:ntriples)
      end

      def export_as_jsonld
        graph.dump(:jsonld, :standard_prefixes => true)
      end

      def export_as_ttl
        graph.dump(:ttl)
      end

      private

      def current_ability
        ::Ability.new(nil) # public user for exports
      end

      def unfiltered_graph
        @unfiltered_graph ||= unfiltered_graph_repository.find(id)
      end

      def unfiltered_graph_repository
        Hydra::ContentNegotiation::CleanGraphRepository.new(connection)
      end

      def connection
        ActiveFedora.fedora.clean_connection
      end
    end
  end
end
