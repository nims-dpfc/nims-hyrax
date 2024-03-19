json.response do
  json.document do
    @presenter.documents.tap do |document|
      doc = document[0]
      json.id doc.id
      index_fields(doc).each do |field_name, field|
        if should_render_index_field? doc, field
          unless ['description_tesim', 'depositor_ti'].include?(field_name)
            json.set! field_name, doc[field_name]
          end
        end
      end
    end
  end
end
