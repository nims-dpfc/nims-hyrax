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

    # check if the identifier is a NIMS PID - if so, it should be displayed as read only
    if scheme_field_value =~ /identifier persistent/i && identifier_field_value =~ /urn\:(DATA|USER)_IDENTIFIER\.dpfc\.nims\.go\.jp\:([a-f0-9\-]+)/i
      # --- scheme
      out << "  <div class='col-md-3'>"
      out << IdentifierService.new.find_by_id(scheme_field_value)[:label]
      out << @builder.hidden_field(scheme_field_name, options.merge(value: scheme_field_value, name: scheme_field_name, id: scheme_field_id))
      out << '  </div>'

      # --- identifier
      out << "  <div class='col-md-9'>"
      out << "  <code>#{identifier_field_value}</code>"
      out << @builder.hidden_field(identifier_field_name, options.merge(value: identifier_field_value, name: identifier_field_name, id: identifier_field_id))
      out << '  </div>'
    else
      # --- scheme
      id_options = IdentifierService.new.select_all_options
      out << "  <div class='col-md-3'>"
      out << template.select_tag(scheme_field_name,
                                 template.options_for_select(id_options, scheme_field_value),
                                 label: '', class: 'select form-control', prompt: 'choose type', id: scheme_field_id)
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
    end

    out << '</div>' # last row
    out
  end
end
