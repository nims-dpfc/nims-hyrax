class NestedIdentifierInput < NestedAttributesInput

protected

  def build_components(attribute_name, value, index, options, parent=@builder.object_name)
    out = ''

    id_statement = value

    # Inherit required for fields validated in nested attributes
    required  = false
    if object.required?(:complex_identifier) and index == 0
      required = true
    end

    # Add remove elemnt only if element repeats
    repeats = options.delete(:repeats)
    repeats = true if repeats.nil?

    # --- scheme and id - single row
    out << "<div class='row'>"

    # --- obj_id_scheme
    field = :obj_id_scheme
    field_name = name_for(attribute_name, index, field, parent)
    field_id = id_for(attribute_name, index, field, parent)
    field_value = id_statement.send(field).first
    id_options = RdssIdentifierTypesService.new.select_all_options

    out << "  <div class='col-md-3'>"
    out << template.select_tag(field_name,
        template.options_for_select(id_options, field_value),
        label: '', class: 'select form-control', prompt: 'choose type', id: field_id)
    out << '  </div>'

    # --- obj_id
    field = :identifier
    field_name = name_for(attribute_name, index, field, parent)
    field_id = id_for(attribute_name, index, field, parent)
    field_value = id_statement.send(field).first

    out << "  <div class='col-md-6'>"
    out << @builder.text_field(field_name,
        options.merge(value: field_value, name: field_name, id: field_id,
            required: required))
    out << '  </div>'

    # --- delete checkbox
    if repeats == true
      field_label = 'Identifier'
      out << "  <div class='col-md-3'>"
      out << destroy_widget(attribute_name, index, field_label, parent)
      out << '  </div>'
    end

    out << '</div>' # last row
    out
  end
end
