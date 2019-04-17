class NestedPersonInput < NestedAttributesInput

protected

  def build_components(attribute_name, value, index, options, parent=@builder.object_name)
    out = ''

    person_statement = value

    # Inherit required for fields validated in nested attributes
    required  = false
    if object.required?(:complex_person) and index == 0
      required = true
    end

    # --- name
    field = :name
    field_name = name_for(attribute_name, index, field, parent)
    field_id = id_for(attribute_name, index, field, parent)
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

    # --- complex_affiliation
    # id_fields = NestedIdentifierInput.new(@builder, :complex_identifier, nil, :multi_value, {})
    # id_fields.send(:)

    field = ''
    field_name1 = name_for(attribute_name, index, field, parent)

    out << "<div class='row'>"
    out << "  <div class='col-md-12'>"
    out << template.label_tag('affiliation', 'Affiliation', required: false)
    out << '  </div>'
    out << '</div>' # row

    # ----- organization
    field_name = field_name1[0..-5] + '[complex_affiliation_attributes][0][complex_organization_attributes][0][organization][]'
    field_id = ''
    field_value = nil
    out << "<div class='row'>"
    out << "  <div class='col-md-3'>"
    out << template.label_tag(field_name, 'Organization', required: false)
    out << '  </div>'
    out << "  <div class='col-md-9'>"
    out << @builder.text_field(field_name,
        options.merge(value: field_value, name: field_name, id: field_id, required: false))
    out << '  </div>'
    out << '</div>' # row

    # ----- sub organization
    field_name = field_name1[0..-5] + '[complex_affiliation_attributes][0][complex_organization_attributes][0][sub_organization][]'
    field_id = ''
    field_value = nil
    out << "<div class='row'>"
    out << "  <div class='col-md-3'>"
    out << template.label_tag(field_name, 'Sub organization', required: false)
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
    field_name = name_for(attribute_name, index, field, parent)
    field_id = id_for(attribute_name, index, field, parent)
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
    out << destroy_widget(attribute_name, index, field_label, parent)
    out << '  </div>'

    out << '</div>' # last row
    out
  end
end
