module Importers
  module ImageImporter
    module ParseXml

      require 'importers/image_importer/profiles'
      include Importers::ImageImporter::Profiles

      def parse_image_file(src_file)
        # Open xml file with namespace
        imeji_xml = Nokogiri::XML('<imeji:items
          xmlns:imeji-metadata="ImejiNamespaces.METADATA"
          xmlns:eprofiles="http://purl.org/escidoc/metadata/profiles/0.1/"
          xmlns:dcterms="http://purl.org/dc/terms/"
          xmlns:foaf="http://xmlns.com/foaf/0.1/"
          xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
          xmlns:ns6="http://imeji.org/terms/metadata/"
          xmlns:eterms="http://purl.org/escidoc/metadata/terms/0.1/"
          xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
          xmlns:dcam="http://purl.org/dc/dcam/"
          xmlns:dc="http://purl.org/dc/elements/1.1/"
          xmlns:imeji="http://imeji.org/terms/"></imeji:items>')
        doc = File.open(src_file) { |f| Nokogiri::XML(f) }
        imeji_xml.root << doc.root.children
        images_metadata = []
        imeji_xml.xpath('./imeji:items/imeji:item').each do |item|
          images_metadata << get_image_metadata(item)
        end
        images_metadata
      end

      def get_image_metadata(image)
        return metadata if image.blank?
        image_metadata = {}
        image_metadata[:metadata] = get_metadata(image)
        visibility = image_metadata[:metadata].fetch(:visibility, 'restricted')
        # files is an array of hashes, with each hash containing
        #   filename, filetype, fileurl, filepath, metadata
        image_metadata[:files] = get_files_info(image, visibility)
        image_metadata[:collection] = get_collection(image)
        image_metadata = set_default_title(image_metadata)
      end

      def get_metadata(image)
        metadata = {}
        # id
        val = get_id(image)
        metadata[:id] = val unless val.blank?
        # issued
        val = get_issued(image)
        if val.any?
          metadata[:complex_date_attributes] ||= []
          metadata[:complex_date_attributes] << val
        end
        # visibility
        val = get_visibility(image)
        metadata[:visibility] = val unless val.blank?
        # version
        val = get_version(image)
        if val.any?
          metadata[:complex_version_attributes] ||= []
          metadata[:complex_version_attributes] << val
        end
        # metadata set
        metadata = get_metadata_set(image, metadata)
        # NOT interested in the following
        # get_created
        # get_creator
        # discardComment
        # escidocId
        # fulltext
        # modified
        # modifiedBy
        # status
        # storageId
        metadata
      end

      def get_files_info(image, visibility)
        # Returns an array of hashes, with each hash containing
        #   filename, filetype, fileurl, filepath, metadata
        files = []
        # checksum - not using
        filename = get_filename(image)
        filetype = get_filetype(image)
        full_image_url = get_full_image_url(image)
        thumbnail_image_url = get_thumbnail_image_url(image)
        web_image_url = get_web_image_url(image)

        unless full_image_url.blank?
          file_info = {}
          this_filename = filename
          this_filename = File.basename(full_image_url) if filename.blank?
          file_info[:filename] = this_filename
          file_info[:filetype] = filetype unless filetype.blank?
          file_info[:fileurl] = full_image_url
          metadata = {}
          metadata[:title] = this_filename
          metadata[:visibility] = 'restricted'
          metadata[:resource_type] = 'Full image'
          file_info[:metadata] = metadata
          files << file_info
        end

        unless web_image_url.blank?
          file_info = {}
          this_filename = filename
          this_filename = File.basename(web_image_url) if filename.blank?
          file_info[:filename] = this_filename
          file_info[:filetype] = filetype unless filetype.blank?
          file_info[:fileurl] = web_image_url
          metadata = {}
          metadata[:title] = this_filename
          metadata[:visibility] = visibility
          metadata[:resource_type] = 'Web image'
          file_info[:metadata] = metadata
          files << file_info
        end

        unless thumbnail_image_url.blank?
          file_info = {}
          this_filename = filename
          this_filename = File.basename(web_image_url) if filename.blank?
          file_info[:filename] = this_filename
          file_info[:filetype] = filetype unless filetype.blank?
          file_info[:fileurl] = thumbnail_image_url
          metadata = {}
          metadata[:title] = this_filename
          metadata[:visibility] = visibility
          metadata[:resource_type] = 'Thumbnail'
          file_info[:metadata] = metadata
          files << file_info
        end
        files
      end

      # ----------------------
      # descriptive metadata
      # ----------------------
      def get_id(image)
        pid = image.attributes.fetch('id', nil)
        pid = pid.value.split('/')[-1] unless pid.blank?
        pid
      end

      def get_issued(image)
        date_attr = {}
        val = get_text(image, 'imeji:checksum')
        desc = DateService.new.find_by_id_or_label('Issued')['id']
        date_attr = {date: val[0], description: desc} if val.any?
        date_attr
      end

      def get_visibility(image)
        visibility = nil
        val = get_text(image, 'imeji:visibility')
        if val.any? and val[0] == 'PUBLIC'
          visibility = 'open'
        else
          visibility = 'restricted'
        end
        visibility
      end

      def get_version(image)
        version = {}
        val = get_text(image, 'imeji:version')
        version = {version: val[0]} if val.any?
        version
      end

      def get_metadata_set(image, metadata)
        image.xpath('./imeji:metadataSet/imeji:metadata').each do |mds|
          val = get_text(mds, './imeji:statement')
          id = val.any? ? val[0] : nil
          return if id.blank?
          label_and_type = profiles.fetch(id, nil)
          return unless label_and_type.any?
          label = label_and_type[0]
          type = label_and_type[1]
          case type
          when 'text'
            vals = get_metadata_set_text(mds)
          when 'number'
            vals = get_metadata_set_number(mds)
          when 'datetime'
            vals = get_metadata_set_datetime(mds)
          when 'uri'
            vals = get_metadata_set_uri(mds)
          when 'person'
            vals = get_metadata_set_person(mds)
          when 'license'
            vals = get_metadata_set_license(mds)
          end
          if mapped_properties.include?(label) and not val.blank?
            case mapped_properties[label]
            when 'author'
              metadata[:complex_person_attributes] ||= []
              metadata[:complex_person_attributes] << vals
            when 'date'
              metadata[:date_created] = [vals]
            when 'description'
              metadata[:description] = [vals]
            when 'identifier'
              metadata[:complex_identifier_attributes] ||= []
              metadata[:complex_identifier_attributes] << { identifier: vals, label: 'DOI'}
            when 'instrument'
              metadata[:instrument] = [vals]
            when 'license'
              unless vals.fetch('identifier', nil).blank?
                metadata[:complex_rights_attributes] ||= []
                attrs = {}
                attrs[:rights] = vals['identifier']
                attrs[:label] = vals['license'] unless vals.fetch('license', nil).blank?
                metadata[:complex_rights_attributes] << attrs
              end
            when 'related_item'
              metadata[:complex_relation_attributes] ||= []
              attrs = {}
              attrs[:title] = vals['label'] unless vals.fetch('label', nil).blank?
              attrs[:url] = vals['uri'] unless vals.fetch('uri', nil).blank?
              attrs[:relationship] = 'isBasisFor'
              metadata[:complex_relation_attributes] << attrs if attrs.any?
            when 'specimen_set'
              metadata[:specimen_set] = [vals]
            when 'title'
              metadata[:title] = [vals]
            end
          elsif custom_propeties.include?(label)
            metadata[:custom_property_attributes] ||= []
            attrs = {}
            attrs[:description] = vals
            attrs[:label] = label
            metadata[:custom_property_attributes] << attrs
          end
        end
        metadata
      end

      def get_metadata_set_text(node)
        val = get_text(node, 'imeji:text')
        val.any? ? val[0] : nil
      end

      def get_metadata_set_datetime(node)
        val = get_text(node, 'imeji:date')
        dt = val.any? ? val[0] : nil
        val = get_text(node, 'imeji:time')
        tm = val.any? ? val[0] : nil
        return nil if dt.blank?
        return "#{dt}T00:00:00" if tm.blank?
        "#{dt}T#{Time.at(tm.to_i).utc.strftime("%H:%M:%S")}"
      end

      def get_metadata_set_number(node)
        val = get_text(node, 'imeji:number')
        val.any? ? val[0] : nil
      end

      def get_metadata_set_uri(node)
        data = {}
        val = get_text(node, 'rdfs:label')
        data['label'] = val[0] if val.any?
        val = get_text(node, 'imeji:uri')
        data['uri'] = val[0] if val.any?
        data
      end

      def get_metadata_set_license(node)
        data = {}
        val = get_text(node, 'dc:identifier')
        data['identifier'] = val[0] if val.any?
        val = get_text(node, 'imeji:license')
        data['license'] = val[0] if val.any?
        data
      end

      def get_metadata_set_person(node)
        data = {}
        val = get_text(node, 'foaf:person/eterms:complete-name')
        data[:name] = val[0] if val.any?
        val = get_text(node, 'foaf:person/eterms:family-name')
        data[:last_name] = val[0] if val.any?
        val = get_text(node, 'foaf:person/eterms:given-name')
        data[:first_name] = val[0] if val.any?
        val = get_text(node, 'foaf:person/dc:identifier')
        data[:complex_identifier_attributes] = [
          { identifier: val[0], label: 'identifier local' }
        ]
        id = get_text(node, 'foaf:person/eprofiles:organizationalunit/dcterms:identifier')
        title = get_text(node, 'foaf:person/eprofiles:organizationalunit/dcterms:title')
        if title.any?
          attrs = { organization: title[0] }
          if id.any?
            attrs[:complex_identifier_attributes] = [
              { identifier: id[0], label: 'identifier local' }
            ]
          end
          data[:complex_organization_attributes] = [attrs]
        end
        data
      end

      # ------------------
      # File metadata
      # ------------------
      def get_checksum(image)
        val = get_text(image, 'imeji:checksum')
        val.any? ? val[0] : nil
      end

      def get_filename(image)
        val = get_text(image, 'imeji:filename')
        val.any? ? val[0] : nil
      end

      def get_filetype(image)
        val = get_text(image, 'imeji:filetype')
        val.any? ? val[0] : nil
      end

      def get_full_image_url(image)
        val = get_text(image, 'imeji:fullImageUrl')
        val.any? ? val[0] : nil
      end

      def get_thumbnail_image_url(image)
        val = get_text(image, 'imeji:thumbnailImageUrl')
        val.any? ? val[0] : nil
      end

      def get_web_image_url(image)
        val = get_text(image, 'imeji:webImageUrl')
        val.any? ? val[0] : nil
      end

      # ------------------
      # collection info
      # ------------------
      def get_collection(image)
        val = get_text(image, 'imeji:collection')
        val.any? ? val[0] : nil
      end

      # -----------------
      # Default title
      # -----------------
      def set_default_title(image_metadata)
        filename = image_metadata.fetch(:file_info, {}).fetch(:filename, nil)
        title = image_metadata.fetch(:metadata, {}).fetch(:title, nil)
        if title.blank? and filename.present?
          image_metadata[:metadata][:title] = ["Image #{filename}"]
        end
        image_metadata
      end

      # ------------------
      # Helper methods
      # ------------------
      def get_text_with_tags(node, element)
        values = []
        node.xpath("./#{element}").each do |ele|
          values << ele.children.to_s
        end
        values.reject { |c| c.empty? }
      end

      def get_text(node, element)
        values = []
        node.xpath("./#{element}").each do |ele|
          values << ele.text.strip if ele.text
        end
        values.reject { |c| c.empty? }
      end

      def get_value_by_attribute(node, element)
        values = {}
        node.xpath("./#{element}").each do |each_ele|
          each_ele.each do |attr_name, attr_value|
            values[attr_name] = attr_value.strip unless attr_value.blank?
          end
        end
        values
      end

    end
  end
end
