json.response do
  json.docs do
    json.array! @presenter.documents do |document|
      json.id document.id
      index_fields(document).each do |field_name, field|
        if should_render_index_field? document, field
          unless ['description_tesim', 'depositor_ti'].include?(field_name)
            json.set! field_name, document[field_name]
          end
        end
      end
    end
  end
  json.facets @presenter.search_facets_as_json
  json.pages @presenter.pagination_info
end
