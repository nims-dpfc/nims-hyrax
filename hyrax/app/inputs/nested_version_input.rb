class NestedVersionInput < NestedAttributesInput

protected

  def build_components(attribute_name, value, index, options, parent=@builder.object_name)
    out = ''

    # Inherit required for fields validated in nested attributes
    required  = false
    if object.required?(:complex_version) and index == 0
      required = true
    end

    # --- version
    field = :version
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

    # --- date
    field = :date
    field_name = name_for(attribute_name, index, field, parent)
    field_id = id_for(attribute_name, index, field, parent)
    field_value = value.send(field).first

    out << "<div class='row'>"
    out << "  <div class='col-md-3'>"
    out << template.label_tag(field_name, field.to_s.humanize, required: required)
    out << '  </div>'

    out << "  <div class='col-md-6'>"
    out << @builder.text_field(field_name,
        options.merge(value: field_value, name: field_name, id: field_id,
            data: { provide: 'datepicker' }, required: required))
    out << '  </div>'

    # --- delete checkbox
    field_label = 'Version'
    out << "  <div class='col-md-3'>"
    out << destroy_widget(attribute_name, index, field_label, parent)
    out << '  </div>'

    out << '</div>' # last row
    out
  end
end
