class NestedSpecimenTypeAttributeRenderer < Hyrax::Renderers::FacetedAttributeRenderer
  private
  def li_value(value)
    value = JSON.parse(value)
    html = []
    value.each do |v|
      specimen = []
      # title
      unless v.dig('title').blank?
        label ="Title"
        val = link_to(ERB::Util.h(v['title'][0]), search_path(v['title'][0]))
        specimen << [label, val]
      end
      # chemical_composition
      unless v.dig('chemical_composition').blank?
        label = 'Chemical composition'
        val = v['chemical_composition'][0]
        specimen << [label, val]
      end
      # crystallographic_structure
      unless v.dig('crystallographic_structure').blank?
        label = 'Crystallographic structure'
        val = v['crystallographic_structure'][0]
        specimen << [label, val]
      end
      # description
      unless v.dig('description').blank?
        label = 'Description'
        val = v['description'][0]
        specimen << [label, val]
      end
      # complex identifier
      unless v.dig('complex_identifier').blank?
        label = 'Identifier'
        unless v['complex_identifier'][0].dig('label').blank?
          label = v['complex_identifier'][0]['label'][0]
          term = IdentifierService.new.find_by_id(label)
          label = term['label'] if term.any?
        end
        val = v['complex_identifier'][0]['identifier'][0]
        specimen << [label, val]
      end
      # material_types
      unless v.dig('material_types').blank?
        label = t('ngdr.fields.material_types')
        val = v['material_types'][0]
        specimen << [label, val]
      end
      #TODO: complex purchase_record
      # Complex relation
      unless v.dig('complex_relation').blank?
        label = t('ngdr.fields.complex_relation')
        r_j = v.dig('complex_relation').to_json
        val = NestedRelationAttributeRenderer.new('complex_relation', r_j).render
        specimen << [label, val]
      end
      # structural_features
      unless v.dig('structural_features').blank?
        label = 'Structural features'
        val = v['structural_features'][0]
        specimen << [label, val]
      end
      html << specimen
    end
    unless html.blank?
      html_out = '<table class="table nested-table"><tbody>'
      html.each do |specimen|
        specimen.each_with_index do |h,index|
          if (index + 1) == specimen.size
            html_out += '<tr class="end">'
          else
            html_out += '<tr>'
          end
          html_out += "<th>#{h[0]}</th><td>#{h[1]}</td></tr>"
        end
      end
      html_out += '</tbody></table>'
    end
    %(#{html_out})
  end
end
