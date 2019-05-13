class NestedRelationInput < NestedAttributesInput

protected

  def build_components(attribute_name, value, index, options, parent=@builder.object_name)
    out = ''

    # Inherit required for fields validated in nested attributes
    required  = false
    if object.required?(:complex_relation) and index == 0
      required = true
    end

    # --- title
    field = :title
    field_name = name_for(attribute_name, index, field, parent)
    field_id = id_for(attribute_name, index, field, parent)
    field_value = value.send(field).first

    out << "<div class='row'>"
    out << "  <div class='col-md-3'>"
    out << template.label_tag(field_name, 'Title', required: required)
    out << '  </div>'

    out << "  <div class='col-md-9'>"
    out << @builder.text_field(field_name,
        options.merge(value: field_value, name: field_name, id: field_id, required: required))
    out << '  </div>'
    out << '</div>' # row

    # --- url
    field = :url
    field_name = name_for(attribute_name, index, field, parent)
    field_id = id_for(attribute_name, index, field, parent)
    field_value = value.send(field).first

    out << "<div class='row'>"
    out << "  <div class='col-md-3'>"
    out << template.label_tag(field_name, field.to_s.humanize, required: required)
    out << '  </div>'

    out << "  <div class='col-md-9'>"
    out << @builder.text_field(field_name,
        options.merge(value: field_value, name: field_name, id: field_id, required: required))
    out << '  </div>'
    out << '</div>' # row

    # # --- identifier
    # field = :identifier
    # field_value = value.send(field).first
    # field_id = id_for(attribute_name, index, field, parent)
    # field_name = name_for(attribute_name, index, field, parent)

    # out << "<div class='row'>"
    # out << "  <div class='col-md-3'>"
    # out << template.label_tag(field_name, field.to_s.humanize, required: false)
    # out << '  </div>'

    # out << "  <div class='col-md-9'>"
    # out << @builder.text_field(field_name,
    #     options.merge(value: field_value, name: field_name, id: field_id, required: false))
    # out << '  </div>'
    # out << '</div>' # row

    # last row
    out << "<div class='row'>"

    # --- relationship
    field = :relationship
    field_name = name_for(attribute_name, index, field, parent)
    field_id = id_for(attribute_name, index, field, parent)
    field_value = value.send(field).first
    role_options = RelationshipService.new.select_all_options

    out << "  <div class='col-md-3'>"
    out << template.label_tag(field_name, 'Relationship', required: required)
    out << '  </div>'

    out << "  <div class='col-md-6'>"
    out << template.select_tag(field_name,
        template.options_for_select(role_options, field_value),
        label: '', class: 'select form-control', prompt: 'choose relationship',
        id: field_id, required: required)
    out << '  </div>'

    # --- delete checkbox
    field_label ='Related work'
    out << "  <div class='col-md-3'>"
    out << destroy_widget(attribute_name, index, field_label, parent)
    out << '  </div>'

    out << '</div>' # last row
    out
  end
end
