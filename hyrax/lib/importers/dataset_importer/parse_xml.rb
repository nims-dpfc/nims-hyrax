module Importers
  module DatasetImporter
    module ParseXml

      def parse_metadata
        @xml_metadata = File.open(@metadata_file) { |f| Nokogiri::XML(f) { |conf| conf.noblanks } }
        @xml_metadata.remove_namespaces!
        get_basic_data_description
        get_specimen_description
        get_instrument_description
        get_specimen_types
        get_characterization_methods
      end

      private

      def get_basic_data_description
        desc = @xml_metadata.xpath("depositUploadReq/common-term/basic-data-description")
        get_persistent_identifiers(desc)
        get_local_identifiers(desc)
        get_stakeholders(desc)
        get_organization(desc)
        get_project_id(desc)
        get_data_history(desc)
        get_data_origin(desc)
        get_license(desc)
        get_visibility(desc)
        set_title
      end

      def get_specimen_description
        #TODO: NIMS to get back on this
      end

      def get_instrument_description
        parent = 'complex_instrument'
        ele = @xml_metadata.xpath('depositUploadReq/common-term/instrument-description')
        ele.each do |inst|
          inst_hash = {}
          get_instrument_identifiers(inst, inst_hash)
          get_instrument_name(inst, inst_hash)
          get_instrument_manufacturer(inst, inst_hash)
          get_instrument_type(inst, inst_hash)
          get_instrument_managing_organization(inst, inst_hash)
          get_instrument_category_code(inst, inst_hash)
          get_instrument_sub_category_code(inst, inst_hash)
          get_instrument_function(inst, inst_hash)
          get_instrument_operator(inst, inst_hash)
          get_instrument_process_date(inst, inst_hash)
          assign_nested_hash(parent, inst_hash, false) if inst_hash.any?
        end
      end

      def get_specimen_types
        parent = 'complex_specimen_type'
        ele = @xml_metadata.xpath('depositUploadReq/domain-specific-term/specimen-types/type')
        ele.each do |st|
          st_hash = {}
          get_specimen_type_persistent_identifiers(st, st_hash)
          get_specimen_type_local_identifiers(st, st_hash)
          get_specimen_type_name(st, st_hash)
          get_specimen_type_description(st, st_hash)
          get_specimen_type_crystallographic_structure(st, st_hash)
          get_specimen_type_chemical_composition(st, st_hash)
          get_specimen_type_structural_feature(st, st_hash)
          get_specimen_type_material_type(st, st_hash)
          get_specimen_type_purchase_record(st, st_hash)
          get_specimen_type_shape(st, st_hash)
          get_specimen_type_state_of_matter(st, st_hash)
          assign_nested_hash(parent, st_hash, false) if st_hash.any?
        end
      end

      def get_characterization_methods
        #TODO: This needs to be modelled
      end

      def get_persistent_identifiers(ele)
        vals = get_text(ele, "data-identifier/data-permanent-identifier")
        vals.each do |val|
          id = {
            identifier: val,
            scheme: 'identifier persistent',
          }
          parent = 'complex_identifier'
          assign_nested_hash(parent, id, false)
        end
      end

      def get_local_identifiers(ele)
        vals = get_text(ele, "data-identifier/data-local-identifier")
        vals.each do |val|
          id = {
            identifier: val,
            scheme: 'identifier local',
          }
          parent = 'complex_identifier'
          assign_nested_hash(parent, id, false)
        end
      end

      def get_stakeholders(ele)
        ele.xpath('stakeholders').children.each do |sh|
          next unless sh.name.end_with? '-identifier'
          person = get_person_hash(sh)
          if person.any?
            parent = 'complex_person'
            assign_nested_hash(parent, person, false)
          end
        end
      end

      def get_organization(ele)
        org_ele = ele.xpath('organization')
        org = get_organization_hash(org_ele)
        if org.any?
          parent = 'complex_organization'
          assign_nested_hash(parent, org, false)
        end
      end

      def get_project_id(ele)
        vals = get_text(ele, 'project/project-identifier')
        if vals.any?
          id = {
            identifier: vals[0],
            scheme: 'project id'
          }
          parent = 'complex_identifier'
          assign_nested_hash(parent, id, false)
        end
      end

      def get_data_history(ele)
        parent = 'complex_date'
        # created date
        vals = get_text(ele, 'data-history/created-date-at-origin')
        if vals.any?
          dt = {
            date: vals[0],
            description: 'http://purl.org/dc/terms/created'
          }
          assign_nested_hash(parent, dt, false)
        end
        # modified date
        vals = get_text(ele, 'data-history/latest-modified-date-at-origin')
        if vals.any?
          dt = {
            date: vals[0],
            description: 'http://bibframe.org/vocab/changeDate'
          }
          assign_nested_hash(parent, dt, false)
        end
        # deposit date
        vals = get_text(ele, 'data-history/deposit-to-core-date')
        if vals.any?
          dt = {
            date: vals[0],
            description: 'Deposited'
          }
          assign_nested_hash(parent, dt, false)
        end
      end

      def get_data_origin(ele)
        vals = get_text(ele, 'data-origin')
        if vals.any?
          term = DataOriginService.new.find_by_id_or_label(vals[0])
          if term.any?
            @attributes[:data_origin] = Array(term['id'])
          else
            @errors << "#{vals[0]} not in data origin authority"
          end
        end
      end

      def get_license(ele)
        vals = get_text(ele, 'licenses/license')
        if vals.any?
          term = RightsService.new.find_by_id_or_label(vals[0])
          if term.any?
            @attributes[:license] = term['id']
          else
            @errors << "#{vals[0]} not in license authority"
          end
        end
      end

      def get_visibility(ele)
        visibility_options = %w(open authenticated embargo lease restricted)
        # TODO: Map all visibility options
        visibility_map = {
          'public' => 'open'
        }
        vals = get_text(ele, 'visibility/visibility')
        if vals.any?
          visibility = nil
          if visibility_map.include?(vals[0].downcase)
            visibility = visibility_map[vals[0].downcase]
          elsif visibility_options.include?(vals[0].downcase)
            visibility = vals[0].downcase
          end
          @attributes[:visibility] = visibility if visibility.present?
        end
      end

      def set_title
        @attributes[:title] = Array(@title) if @title.present?
      end

      def get_instrument_identifiers(ele, inst_hash)
        vals = get_text(ele, "identifier/local-identifier")
        vals.each do |val|
          id = {
            identifier: val,
            scheme: 'identifier local',
          }
          parent = 'complex_identifier'
          assign_nested_hash(parent, id, false, inst_hash)
        end
      end

      def get_instrument_name(ele, inst_hash)
        vals = get_text(ele, 'name')
        inst_hash[:title] = vals[0] if vals.any?
      end

      def get_instrument_manufacturer(ele, inst_hash)
        org_ele = ele.xpath('manufacturer')
        org = get_organization_hash(org_ele, 'Manufacturer')
        if org.any?
          parent = 'complex_organization'
          assign_nested_hash(parent, org, false, inst_hash)
        end
      end

      def get_instrument_type(ele, inst_hash)
        vals = get_text(ele, 'instrument-type')
        inst_hash[:model_number] = vals[0] if vals.any?
      end

      def get_instrument_managing_organization(ele, inst_hash)
        org_ele = ele.xpath('managing-organization')
        org = get_organization_hash(org_ele, 'Managing organization')
        if org.any?
          parent = 'complex_organization'
          assign_nested_hash(parent, org, false, inst_hash)
        end
      end

      def get_instrument_category_code(ele, inst_hash)
        #TODO: NIMS to get back on this
      end

      def get_instrument_sub_category_code(ele, inst_hash)
        # TODO: NIMS to get back on this
      end

      def get_instrument_function(ele, inst_hash)
        # TODO: NIMS to get back on this
        # The xml is as follows
        #   <instrument-function>
        #     <column-number></column-number>
        #     <tier-number></tier-number>
        #   </instrument-function>
        #   <instrument-function>
        #     <column-number>4</column-number>
        #     <tier-number>0001**</tier-number>
        #     <tier-number>0002**</tier-number>
        #     <tier-number>0003**</tier-number>
        #     <tier-number>0004**</tier-number>
        #   </instrument-function>
        # Instrument function has been modelled with the following fields
        #   column_number
        #   category
        #   sub_category
        #   description
      end

      def get_instrument_operator(ele, inst_hash)
        people_ele = ele.xpath('operator-identifier')
        people_ele.each do |person_ele|
          person = get_person_hash(person_ele)
          if person.any?
            parent = 'complex_person'
            assign_nested_hash(parent, person, false, inst_hash)
          end
        end
      end

      def get_instrument_process_date(ele, inst_hash)
        vals = get_text(ele, 'process-date')
        if vals.any?
          dt = {
            date: vals[0],
            description: 'Processed'
          }
          parent = 'complex_date'
          assign_nested_hash(parent, dt, false, inst_hash)
        end
      end

      def get_specimen_type_persistent_identifiers(ele, st_hash)
        parent = 'complex_identifier'
        vals = get_text(ele, "specimen-identifier/pid")
        vals.each do |val|
          id = {
            identifier: val,
            scheme: 'identifier persistent',
          }
          assign_nested_hash(parent, id, false, st_hash)
        end
      end

      def get_specimen_type_local_identifiers(ele, st_hash)
        parent = 'complex_identifier'
        vals = get_text(ele, "specimen-identifier/local-identifier")
        vals.each do |val|
          id = {
            identifier: val,
            scheme: 'identifier local',
          }
          assign_nested_hash(parent, id, false, st_hash)
        end
      end

      def get_specimen_type_name(ele, st_hash)
        vals = get_text(ele, 'general-name')
        st_hash[:title] = vals if vals.any?
      end

      def get_specimen_type_description(ele, st_hash)
        vals = get_text(ele, 'description')
        st_hash[:description] = vals if vals.any?
      end

      def get_specimen_type_crystallographic_structure(ele, st_hash)
        # TODO: This is incomplete. NIMS to get back on this
        vals_1 = get_text(ele, 'crystallographic-structure/code-type')
        vals_2 = get_text(ele, 'crystallographic-structure/class')
        vals = vals_1 + vals_2
        if vals.any?
          cs_hash = { description: vals.join(' ') }
          parent = 'complex_crystallographic_structure'
          assign_nested_hash(parent, cs_hash, false, st_hash)
        end
      end

      def get_specimen_type_chemical_composition(ele, st_hash)
        parent = 'complex_chemical_composition'
        ele.xpath('chemical-composition').each do |cc|
          cc_hash = {}
          get_chemical_composition_identifier(cc, cc_hash)
          get_chemical_composition_description(cc, cc_hash)
          assign_nested_hash(parent, cc_hash, false, st_hash) if cc_hash.any?
        end
      end

      def get_chemical_composition_identifier(ele, cc_hash)
        parent = 'complex_identifier'
        ele.xpath('chemical-composition-identifier').each do |id|
          vals = get_identifier_hash(id)
          assign_nested_hash(parent, vals, false, cc_hash) if vals.any?
        end
      end

      def get_chemical_composition_description(ele, cc_hash)
        vals = get_text(ele, 'chemical-composition-description')
        cc_hash[:description] = vals[0] if vals.any?
      end

      def get_specimen_type_structural_feature(ele, st_hash)
        parent = 'complex_structural_feature'
        ele.xpath('structural-features').each do |sf|
          sf_hash = {}
          get_structural_feature_identifier(sf, sf_hash)
          get_structural_feature_description(sf, sf_hash)
          get_structural_feature_category(sf, sf_hash)
          get_structural_feature_sub_category(sf, sf_hash)
          assign_nested_hash(parent, sf_hash, false, st_hash) if sf_hash.any?
        end
      end

      def get_structural_feature_identifier(ele, sf_hash)
        parent = 'complex_identifier'
        ele.xpath('structural-features-identifier').each do |id|
          vals = get_identifier_hash(id)
          assign_nested_hash(parent, vals, false, sf_hash) if vals.any?
        end
      end

      def get_structural_feature_description(ele, sf_hash)
        vals = get_text(ele, 'structural-features-description')
        sf_hash[:description] = vals[0] if vals.any?
      end

      def get_structural_feature_category(ele, sf_hash)
        vals = get_text(ele, 'structural-features-category')
        sf_hash[:category] = vals[0] if vals.any?
      end

      def get_structural_feature_sub_category(ele, sf_hash)
        vals = get_text(ele, 'structural-features-subcategory')
        sf_hash[:sub_category] = vals[0] if vals.any?
      end

      def get_specimen_type_material_type(ele, st_hash)
        parent = 'complex_material_type'
        ele.xpath('material-type').each do |mt|
          mt_hash = {}
          get_material_type_identifier(mt, mt_hash)
          get_material_type_description(mt, mt_hash)
          get_material_type_material_type(mt, mt_hash)
          get_material_type_material_sub_type(mt, mt_hash)
          assign_nested_hash(parent, mt_hash, false, st_hash) if mt_hash.any?
        end
      end

      def get_material_type_identifier(ele, mt_hash)
        parent = 'complex_identifier'
        ele.xpath('material-type-identifier').each do |id|
          vals = get_identifier_hash(id)
          assign_nested_hash(parent, vals, false, mt_hash) if vals.any?
        end
      end

      def get_material_type_description(ele, mt_hash)
        # description
        vals = get_text(ele, 'material-type-description')
        mt_hash[:description] = vals[0] if vals.any?
      end

      def get_material_type_material_type(ele, mt_hash)
        vals = get_text(ele, 'material-type')
        mt_hash[:material_type] = vals[0] if vals.any?
      end

      def get_material_type_material_sub_type(ele, mt_hash)
        vals = get_text(ele, 'sub-material-type')
        mt_hash[:material_sub_type] = vals[0] if vals.any?
      end

      def get_specimen_type_purchase_record(ele, st_hash)
        parent = 'complex_purchase_record'
        ele.xpath('purchase').each do |pr|
          pr_hash = {}
          get_purchase_record_date(pr, pr_hash)
          get_purchase_record_identifier(pr, pr_hash)
          get_purchase_record_supplier(pr, pr_hash)
          get_purchase_record_manufacturer(pr, pr_hash)
          assign_nested_hash(parent, pr_hash, false, st_hash) if pr_hash.any?
        end
      end

      def get_purchase_record_date(ele, pr_hash)
        vals = get_text(ele, 'purchase-date')
        pr_hash[:date] = vals if vals.any?
      end

      def get_purchase_record_identifier(ele, pr_hash)
        parent = 'complex_identifier'
        vals = get_text(ele, "lot-identifier")
        vals.each do |val|
          id = {
            identifier: val,
            scheme: 'identifier local',
          }
          assign_nested_hash(parent, id, false, pr_hash)
        end
      end

      def get_purchase_record_supplier(ele, pr_hash)
        parent = 'supplier'
        org_ele = ele.xpath('supplier')
        org = get_organization_hash(org_ele, 'Supplier')
        if org.any?
          assign_nested_hash(parent, org, false, pr_hash)
        end
      end

      def get_purchase_record_manufacturer(ele, pr_hash)
        parent = 'manufacturer'
        org_ele = ele.xpath('item/manufacturer')
        org = get_organization_hash(org_ele, 'Manufacturer')
        if org.any?
          assign_nested_hash(parent, org, false, pr_hash)
        end
      end

      def get_specimen_type_shape(ele, st_hash)
        # TODO: NIMS to get back on this
        # The xml is as follows
        #   <status>
        #     <type>form</type>
        #     <form-name>plate</form-name>
        #   </status>
        #   <status>
        #     <type>form</type>
        #     <form-name>solid</form-name>
        #   </status>
        # complex_shape has been modelled with the following fields
        #   complex_identifier
        #   description
      end

      def get_specimen_type_state_of_matter(ele, st_hash)
        # TODO: NIMS to get back on this
        # The xml is as follows
        #   <status>
        #     <type>form</type>
        #     <form-name>plate</form-name>
        #   </status>
        #   <status>
        #     <type>form</type>
        #     <form-name>solid</form-name>
        #   </status>
        # complex_state_of_matter has been modelled with the following fields
        #   complex_identifier
        #   description
      end

      # =================================
      # helpful methods
      # =================================

      def get_text(node, element)
        values = []
        node.search("./#{element}").each do |ele|
          values << ele.text.strip if ele.text
        end
        values.reject { |c| c.empty? }
      end

      def assign_nested_hash(parent, values, merge=true, metadata_hash=@attributes)
        metadata_hash["#{parent}_attributes".to_sym] ||= []
        if merge
          vals = metadata_hash["#{parent}_attributes".to_sym].first
          vals ||= {}
          vals.merge!(values)
          metadata_hash["#{parent}_attributes".to_sym] = [vals]
        else
          metadata_hash["#{parent}_attributes".to_sym] << values
        end
        metadata_hash
      end

      def get_person_hash(ele)
        person = {}
        # name
        vals = get_text(ele, 'description')
        person[:name] = vals[0] if vals.any?
        # identifier
        vals = get_text(ele, 'nims-identifier')
        if vals.any?
          person[:complex_identifier_attributes] = [{
            identifier: vals[0],
            scheme: 'nims person id'
          }]
        end
        # role
        role = ele.name.split('-identifier', -1)[0].gsub('-', ' ')
        person[:role] = role if person.any?
        person
      end

      def get_organization_hash(ele, purpose=nil)
        # TODO: Add ientifier
        org = {}
        vals = get_text(ele, 'organization-description/title-major-organization')
        org[:organization] = vals[0] if vals.any?
        vals = get_text(ele, 'organization-description/title-sub-organization')
        org[:sub_organization] = vals[0] if vals.any?
        org[:purpose] = purpose if org.any? and purpose.present?
        org
      end

      def get_identifier_hash(ele, type=nil)
        id_hash = {}
        ids = []
        ele.children.each do |ch|
          vals = get_text(ele, ch.name)
          next unless vals.any?
          if ch.name == 'identifier-type'
            term = IdentifierService.new.find_by_id_or_label(vals[0])
            if term.any?
              id_hash[:label] = term['id']
            else
              @errors << "#{vals[0]} not in identifier authority"
            end
          else
            ids << vals[0] if vals.any?
          end
        end
        id_hash[:identifier] = ids.uniq if ids.any?
        id_hash
      end

    end
  end
end
