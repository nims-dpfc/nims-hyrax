# Filters the RDF graph to remove some statements (abstract, supervisor) for ttl, nt and jsonld APIs (though not used by html or json)

module FilteredGraph
  private

  def graph
    RDF::Graph.new.insert(*unfiltered_graph.each_statement.to_a.reject { |statement| exclude?(statement) })
  end

  def unfiltered_graph
    Hyrax::GraphExporter.new(solr_document, request).fetch
  end

  def exclude?(statement)
    (statement.predicate.ends_with?('purl.org/dc/elements/1.1/description') && @current_ability.cannot?(:read_abstract, model_name.name.constantize)) ||
        (statement.predicate.ends_with?('www.nims.go.jp/vocabs/ngdr/supervisor-approval'))
  end
end
