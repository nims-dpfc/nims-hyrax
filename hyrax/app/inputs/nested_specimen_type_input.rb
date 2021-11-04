class NestedSpecimenTypeInput < NestedAttributesInput

protected

  def build_components(attribute_name, value, index, options, parent=@builder.object_name)
    out = ''

    # Inherit required for fields validated in nested attributes
    required  = false
    if object.required?(:complex_person) and index == 0
      required = true
    end

    # Add remove element only if element repeats
    repeats =options.delete(:repeats)
    repeats = true if repeats.nil?

    parent_attribute = name_for(attribute_name, index, '', parent)[0..-5]

    # --- title
    field = :title
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

    # --- description
    field = :description
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

    # --- complex_chemical_composition
    field = :complex_chemical_composition
    field_value = value.send(field)
    if field_value.blank?
      value.complex_chemical_composition.build
      field_value = value.send(field)
    end
    nested_fields = NestedChemicalCompositionInput.new(@builder, field, nil, :multi_value, {})
    out << "<div class='inner-nested'>"
    out << "<div class='form-group'>"
    out << "  <label class='control-label optional' for='dataset_#{field.to_s}'>Chemical composition</label>"
    out << nested_fields.nested_input({:class=>"form-control", :repeats => false}, field_value, parent_attribute)
    out << "</div>"
    # out << "  <button type='button' class='btn btn-link add'>"
    # out << "    <span class='glyphicon glyphicon-plus'></span>"
    # out << "    <span class='controls-add-text'>Add another chemical composition</span>"
    # out << "  </button>"
    out << "</div>" # row

    # --- complex_crystallographic_structure
    field = :complex_crystallographic_structure
    field_value = value.send(field)
    if field_value.blank?
      value.complex_crystallographic_structure.build
      field_value = value.send(field)
    end
    nested_fields = NestedCrystallographicStructureInput.new(@builder, field, nil, :multi_value, {})
    out << "<div class='inner-nested'>"
    out << "<div class='form-group'>"
    out << "  <label class='control-label optional' for='dataset_#{field.to_s}'>Crystallographic structure</label>"
    out << nested_fields.nested_input({:class=>"form-control", :repeats => false}, field_value, parent_attribute)
    out << "</div>"
    # out << "  <button type='button' class='btn btn-link add'>"
    # out << "    <span class='glyphicon glyphicon-plus'></span>"
    # out << "    <span class='controls-add-text'>Add another crystallographic structure</span>"
    # out << "  </button>"
    out << "</div>" # row

    # --- complex_material_type
    field = :complex_material_type
    field_value = value.send(field)
    if field_value.blank?
      value.complex_material_type.build
      field_value = value.send(field)
    end
    nested_fields = NestedMaterialTypeInput.new(@builder, field, nil, :multi_value, {})
    out << "<div class='inner-nested'>"
    out << "<div class='form-group'>"
    out << "  <label class='control-label optional' for='dataset_#{field.to_s}'>Material type</label>"
    out << nested_fields.nested_input({:class=>"form-control", :repeats => false}, field_value, parent_attribute)
    out << "</div>"
    # out << "  <button type='button' class='btn btn-link add'>"
    # out << "    <span class='glyphicon glyphicon-plus'></span>"
    # out << "    <span class='controls-add-text'>Add another material type</span>"
    # out << "  </button>"
    out << "</div>" # row

    # --- complex_purchase_record
    field = :complex_purchase_record
    field_value = value.send(field)
    if field_value.blank?
      value.complex_purchase_record.build
      field_value = value.send(field)
    end
    nested_fields = NestedPurchaseRecordInput.new(@builder, field, nil, :multi_value, {})
    out << "<div class='inner-nested'>"
    out << "<div class='form-group'>"
    out << "  <label class='control-label optional' for='dataset_#{field.to_s}'>Purchase record</label>"
    out << nested_fields.nested_input({:class=>"form-control", :repeats => false}, field_value, parent_attribute)
    out << "</div>"
    # out << "  <button type='button' class='btn btn-link add'>"
    # out << "    <span class='glyphicon glyphicon-plus'></span>"
    # out << "    <span class='controls-add-text'>Add another purchase record</span>"
    # out << "  </button>"
    out << "</div>" # row

    # --- complex_structural_feature
    field = :complex_structural_feature
    field_value = value.send(field)
    if field_value.blank?
      value.complex_structural_feature.build
      field_value = value.send(field)
    end
    nested_fields = NestedStructuralFeatureInput.new(@builder, field, nil, :multi_value, {})
    out << "<div class='inner-nested'>"
    out << "<div class='form-group'>"
    out << "  <label class='control-label optional' for='dataset_#{field.to_s}'>Structural feature</label>"
    out << nested_fields.nested_input({:class=>"form-control", :repeats => false}, field_value, parent_attribute)
    out << "</div>"
    # out << "  <button type='button' class='btn btn-link add'>"
    # out << "    <span class='glyphicon glyphicon-plus'></span>"
    # out << "    <span class='controls-add-text'>Add another structural feature</span>"
    # out << "  </button>"
    out << "</div>" # row

    # last row
    # --- delete checkbox
    if repeats == true
      out << "<div class='row'>"
      field_label = 'Specimen type'
      out << "  <div class='col-md-3'>"
      out << destroy_widget(attribute_name, index, field_label, parent)
      out << '  </div>'
      out << '</div>' # row
    end

    out
  end
end
