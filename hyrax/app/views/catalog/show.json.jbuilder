json.response do
  json.document do
    @presenter.documents.tap do |document|
      json.id document.id
      index_fields(document).each do |field_name, field|
        if should_render_index_field? document, field
          json.set! field_name, document[field_name]
        end
      end
    end
  end
end
