class NestedIdentifierInput < NestedAttributesInput

protected

  def build_components(attribute_name, value, index, options, parent=@builder.object_name)
    out = ''

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

    scheme_field = :scheme
    scheme_field_name = name_for(attribute_name, index, scheme_field, parent)
    scheme_field_id = id_for(attribute_name, index, scheme_field, parent)
    scheme_field_value = value.send(scheme_field).first

    identifier_field = :identifier
    identifier_field_name = name_for(attribute_name, index, identifier_field, parent)
    identifier_field_id = id_for(attribute_name, index, identifier_field, parent)
    identifier_field_value = value.send(identifier_field).first
    # --- scheme
    id_options = IdentifierService.new.select_all_options
    out << "  <div class='col-md-3'>"
    out << template.select_tag(scheme_field_name,
                               template.options_for_select(id_options, scheme_field_value),
                               label: '', class: 'select form-control', prompt: 'choose type', id: scheme_field_id,
                               disabled: true
                              )
    out << '  </div>'

    # --- identifier
    out << "  <div class='col-md-6'>"
    out << @builder.text_field(identifier_field_name,
                               options.merge(value: identifier_field_value, name: identifier_field_name, id: identifier_field_id,
                                             required: required))
    out << '  </div>'

    # --- delete checkbox
    if repeats == true
      out << "  <div class='col-md-3'>"
      out << destroy_widget(attribute_name, index, 'Identifier', parent)
      out << '  </div>'
    end

    out << '</div>' # last row
    out
  end
end
