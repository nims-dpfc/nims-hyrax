module Hyrax
  # Retrieves the graph for an object with the internal triples removed
  # and the uris translated to external uris.
  class GraphExporter
    # @param [SolrDocument] solr_document idea here is that in the future, ActiveFedora may serialize the object as JSON+LD
    # @param [ActionDispatch::Request] request the http request context
    def initialize(solr_document, request)
      @solr_document = solr_document
      @request = request
      @additional_resources = []
      @visited_subresources = Set.new
    end

    attr_reader :solr_document, :request, :additional_resources

    # @return [RDF::Graph]
    def fetch
      clean_graph_repository.find(solr_document.id).tap do |g|
        additional_resources.each { |subgraph| g << subgraph }
      end
    rescue Ldp::NotFound
      # this error is handled with a 404 page.
      raise ActiveFedora::ObjectNotFoundError
    end

    private

      def clean_graph_repository
        Hydra::ContentNegotiation::CleanGraphRepository.new(connection, replacer)
      end

      def connection
        @connection ||= CleanConnection.new(ActiveFedora.fedora.connection)
      end

      # This method is called once for each statement in the graph.
      def replacer
        lambda do |resource_id, graph|
          return unless resource_id
          url = ActiveFedora::Base.id_to_uri(resource_id)
          klass = graph.query([:s, ActiveFedora::RDF::Fcrepo::Model.hasModel, :o]).first.object.to_s.constantize

          # if the subject URL matches
          if graph.query([RDF::URI(url), ActiveFedora::RDF::Fcrepo::Model.hasModel, nil]).first
            subject_replacer(klass, resource_id)
          elsif resource_id.start_with? solr_document.id
            subresource_replacer(resource_id, klass)
          else
            object_replacer(resource_id, graph)
          end
        end
      end

      def subresource_replacer(resource_id, parent_klass)
        return subject_replacer(parent_klass, resource_id) unless resource_id.include?('/')

        parent_id, local = resource_id.split('/', 2)

        if @visited_subresources.add?(resource_id)
          additional_resources << ListSourceExporter.new(
            resource_id,
            request,
            subject_replacer(parent_klass, parent_id)
          ).fetch
        end

        parent = subject_replacer(parent_klass, parent_id)
        "#{parent}/#{local}"
      end

      def subject_replacer(klass, resource_id, anchor = nil)
        route_key = if Hyrax.config.curation_concerns.include?(klass)
                      klass.model_name.singular_route_key
                    else
                      SolrDocument.model_name.singular_route_key
                    end
        routes = Rails.application.routes.url_helpers
        builder = ActionDispatch::Routing::PolymorphicRoutes::HelperMethodBuilder
        resource_id = RDF::URI(resource_id)
        new_uri = RDF::URI(builder.polymorphic_method(routes, route_key, nil, :url, id: resource_id.path, host: hostname, anchor: anchor))
        new_uri.fragment = resource_id.fragment
        new_uri
      end

      def object_replacer(id, _graph)
        id, anchor = id.split('/', 2)
        Rails.application.routes.url_helpers.solr_document_url(id, host: hostname, anchor: anchor)
      end

      def hostname
        request.host
      end
  end
end
