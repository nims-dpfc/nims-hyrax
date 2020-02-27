json.response do
  json.docs do
    json.array! @presenter.documents do |document|
      index_fields(document).each do |field_name, field|
        if should_render_index_field? document, field
          json.set! field_name, document[field_name]
        end
      end
    end
  end
  json.facets @presenter.search_facets_as_json
  json.pages @presenter.pagination_info
end
