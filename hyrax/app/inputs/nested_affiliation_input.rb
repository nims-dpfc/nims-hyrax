class NestedAffiliationInput < NestedAttributesInput

protected

  def build_components(attribute_name, value, index, options, parent=@builder.object_name)
    out = ''

    affiliation_statement = value

    # Inherit required for fields validated in nested attributes
    required  = false
    if object.required?(:complex_person) and index == 0
      required = true
    end

    # Add remove element only if element repeats
    repeats =options.delete(:repeats)
    repeats = true if repeats.nil?

    # --- complex_organization
    field = :complex_organization
    field_value = affiliation_statement.send(field)
    if field_value.blank?
      affiliation_statement.complex_organization.build
      field_value = affiliation_statement.send(field)
    end
    puts '-'*70
    puts field_value
    id_parent = name_for(attribute_name, index, '', parent)[0..-5]
    id_input = NestedOrganizationInput.new(@builder, field, nil, :multi_value, {})
    out << "<div class='inner-nested'>"
    out << "<div class='form-group'>"
    # out << "  <label class='control-label optional' for='dataset_complex_orgnaization'>Organization</label>"
    out << id_input.nested_input({:class=>"form-control", :repeats => false}, field_value, id_parent)
    out << "</div>"
    # out << "  <button type='button' class='btn btn-link add'>"
    # out << "    <span class='glyphicon glyphicon-plus'></span>"
    # out << "    <span class='controls-add-text'>Add another identifier</span>"
    # out << "  </button>"
    out << "</div>" # row

    # last row
    out << "<div class='row'>"

    # --- job_title
    field = :job_title
    field_name = name_for(attribute_name, index, field, parent)
    field_id = id_for(attribute_name, index, field, parent)
    field_value = affiliation_statement.send(field).first

    out << "  <div class='col-md-3'>"
    out << template.label_tag(field_name, field.to_s.humanize, required: required)
    out << '  </div>'

    out << "  <div class='col-md-6'>"
    out << @builder.text_field(field_name,
        options.merge(value: field_value, name: field_name, id: field_id, required: false))
    out << '  </div>'

    # --- delete checkbox
    if repeats == true
      field_label = 'Person'
      out << "  <div class='col-md-3'>"
      out << destroy_widget(attribute_name, index, field_label, parent)
      out << '  </div>'
    end

    out << '</div>' # last row
    out
  end
end
