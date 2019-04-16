class NestedPersonInput < NestedAttributesInput

protected

  def build_components(attribute_name, value, index, options)
    out = ''

    person_statement = value

    # Inherit required for fields validated in nested attributes
    required  = false
    if object.required?(:complex_person) and index == 0
      required = true
    end

    # --- name
    field = :name
    field_name = name_for(attribute_name, index, field)
    field_id = id_for(attribute_name, index, field)
    field_value = person_statement.send(field).first

    out << "<div class='row'>"
    out << "  <div class='col-md-3'>"
    out << template.label_tag(field_name, field.to_s.humanize, required: required)
    out << '  </div>'

    out << "  <div class='col-md-9'>"
    out << @builder.text_field(field_name,
        options.merge(value: field_value, name: field_name, id: field_id, required: required))
    out << '  </div>'
    out << '</div>' # row

    --- affiliation
    field = :affiliation
    field_name = name_for(attribute_name, index, field)
    field_id = id_for(attribute_name, index, field)
    field_value = person_statement.send(field).first

    out << "<div class='row'>"
    out << "  <div class='col-md-3'>"
    out << template.label_tag(field_name, field.to_s.humanize, required: false)
    out << '  </div>'

    out << "  <div class='col-md-9'>"
    out << @builder.text_field(field_name,
        options.merge(value: field_value, name: field_name, id: field_id, required: false))
    out << '  </div>'
    out << '</div>' # row

    # last row
    out << "<div class='row'>"

    # --- role
    role_options = RoleService.new.select_all_options
    field = :role
    field_name = name_for(attribute_name, index, field)
    field_id = id_for(attribute_name, index, field)
    field_value = person_statement.send(field).first

    out << "  <div class='col-md-3'>"
    out << template.label_tag(field_name, field.to_s.humanize, required: required)
    out << '  </div>'

    out << "  <div class='col-md-6'>"
    out << template.select_tag(field_name, template.options_for_select(role_options, field_value),
        prompt: 'Select role played', label: '', class: 'select form-control', id: field_id, required: required)
    out << '  </div>'

    # --- delete checkbox
    field_label = 'Person'
    out << "  <div class='col-md-3'>"
    out << destroy_widget(attribute_name, index, field_label)
    out << '  </div>'

    out << '</div>' # last row
    out
  end
end
