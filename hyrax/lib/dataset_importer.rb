
require 'nokogiri'

module DatasetImporter
  class Importer
    attr_reader :object, :work_id, :attributes, :import_dir, :metadata_filename

    def initialize(import_dir='/home/cloo/nims_data_import', metadata_filename='mandatory.xml')
      @work_klass = Dataset
      @import_dir = import_dir
      @metadata_filename = metadata_filename
    end

    def perform_create
      unless File.directory?(import_dir)
        puts 'Directory does not exist at ' + import_dir
        return
      end
      
      # for each dir in the import_dir, parse the mandatory.xml file and upload all other files
      # Some examples have measurement.xml, meta.xml, meta_unit.xml - these are not parsed, just treated as files to be uploaded
      Dir.glob(File.join(import_dir, '**', '*')) |dir|
        fn = dir + '/' + metadata_filename
        unless File.file?(fn)
          puts 'Directory does not contain a mandatory file at ' + fn
          next
        end
        
        # parse the mandatory metadata file
        attributes = parse_metadata(metadata_filename, true)
        if attributes.blank?
          puts 'No suitable attributes available, skipping import of ' + dir
          next
        end
        work_id ||= SecureRandom.uuid # can this ever come from the metadata?
        # list all the files to be uploaded for this item - should this be everything that was in the folder? or not the mandatory.xml?
        # fow now include the mandatory.xml, may be useful for debugging
        files = Dir.glob(File.join(dir, '**', '*'))
        file_ids = [] # we get the file IDs back from the upload process, to attach to the metadata attributes
        unless files.blank?
          file_ids = upload_files(files)
        end
        add_work(work_id,attributes,file_ids)
      end

      true
    end

    private
      # Extract metadata and return as attributes
      def parse_metadata(metadata_filename)
        attributes = {}
        metadata = File.open(metadata_filename) { |f| Nokogiri::XML(f) }
        
        # To import the sample data in: https://github.com/antleaf/nims-ngdr-development-2018/tree/master/sample_data_from_msuzuki
        # the model object is: https://github.com/antleaf/nims-hyrax/blob/develop/hyrax/app/models/dataset.rb
        # fields that have multiple fields have been called ComplexXXX. 
        # For example see complex_date https://github.com/antleaf/nims-hyrax/blob/develop/hyrax/app/models/concerns/complex_date.rb
        # Complex object validation is handled by https://github.com/antleaf/nims-hyrax/blob/develop/hyrax/app/models/concerns/complex_validation.rb
        # The model object is based on a model NIMS provided: http://ngdr.antleaf.com/contexts/datasets/

        # A sample mandatory file: https://github.com/antleaf/nims-ngdr-development-2018/blob/master/sample_data_from_msuzuki/AES-narrow/mandatory.xml

        # There are fields such as instrument_type, which in http://ngdr.antleaf.com/contexts/datasets/ 
        # links instrument to instrument application profile at http://ngdr.antleaf.com/profiles/ngdr_instrument/
        # This shows a line with a label "instrument type" has property name "alternative title" so it would be saved into the model as: 
        # https://github.com/antleaf/nims-hyrax/blob/develop/hyrax/app/models/concerns/complex_instrument.rb#L6

        # NOTE there are errors in the test data such as "specime" instead of "specimen":
        # https://github.com/antleaf/nims-ngdr-development-2018/blob/master/sample_data_from_msuzuki/AES-narrow/mandatory.xml#L16
        # There are a few errors in other places, e.g. authority files having incorrect spellings. Any mandatory.xml file that 
        # contains data that does not match the models and authority files provided by NIMS will not be imported, and a message will be output to terminal

        # NOTE that in config/authorities, if the field key is in there, the value has to be one of the values in the corresponding file
        # can access those file by their relevant service though, in app/services/ like
        # opts = AnalysisFieldService.new.select_all_options where opts would be a list of lists with values term, id
        # then try to find the term in the list of objects
        # can do AnalysisFieldService.label(VALUE) where label is the term in the yml file
        # but WE DON'T KNOW IF THE VALUES IN THE XML ARE THE IDs OR THE TERMS...
        # if it is not found will throw a key error - in which case do not accept the import at all
        # if it is found, I must replace whatever we do have with the ID value from the authority file
        
        # All the valid keys of the Dataset attributes are listed below - try to read each into the metadata
        metadata.xpath('//meta').each do |meta|
          # description: ['description 1'],
          if meta['key'] == 'material_description'
            attributes['description'] ||= []
            attributes['description'] << meta.content

          # rights_statement: ['rights_statement 1'],
          # NOTE that the value in data_accessibility would not be acceptable to the rights_statements authority file
          # see below for more notes on what to do with this data...
          elsif meta['key'] == 'data_accessibility'
            attributes['rights_statement'] ||= []
            attributes['rights_statement'] << meta.content

          # data_origin: ['informatics and data science'],
          # TODO this value needs to be validated against the data_origin authority file
          # see https://github.com/antleaf/nims-hyrax/tree/develop/hyrax/config/authorities
          elsif meta['key'] == 'data_origin'
            attributes['data_origin'] ||= []
            attributes['data_origin'] << meta.content

          # complex_identifier_attributes: [{identifier: '0000-0000-0000-0000', scheme: 'uri_of_ORCID_scheme', label: 'ORCID'}],
          elsif meta['key'] == 'data_id' or meta['key'] == 'previous_process_id' or meta['key'] == 'relational_id' or meta['key'] == 'reference'
            attributes['complex_identifier_attributes'] ||= []
            attributes['complex_identifier_attributes'] << {identifier: meta.content, label: meta['key']}

          # complex_date_attributes: [{date: '1978-10-28', description: 'http://purl.org/dc/terms/issued',}],
          # TODO the dates authority file would not allow these, but it is not clear what descriptions should be used
          # Processed would perhaps match for processing_data, but there is not a good one for data_registration_date
          # NOTE created and modified are also present in the sample XML, but as all are the same it is not clear if 
          # this is data that should be imported into the system or if new created/modified dates relevant to import time
          # should be all that is required (in which case they will be added automatically when the attributes are saved)
          elsif meta['key'] == 'data_registration_date' or meta['key'] == 'processing_data'
            attributes['complex_date_attributes'] ||= []
            attributes['complex_date_attributes'] << {date: meta.content, description: meta['key']}

          # complex_person_attributes: [{
          #   name: 'Foo Bar',
          #   uri: 'http://localhost/person/1234567', 
          #   affiliation: 'author affiliation',
          #   role: 'Author', 
          #   complex_identifier_attributes: [{identifier: '1234567',scheme: 'Local'}]
          # }],
          elsif meta['key'] == 'entrant'
            attributes['complex_person_attributes'] ||= [{}]
            attributes['complex_person_attributes'][0]['complex_identifier_attributes'] = [{identifier: meta.content, scheme: 'Local'}]

          elsif meta['key'] == 'entrant_affiliation'
            attributes['complex_person_attributes'] ||= [{}]
            attributes['complex_person_attributes'][0]['affiliation'] = meta.content

          # instrument_attributes: [{
          #   title: 'Instrument title'
          elsif meta['key'] == 'instrument_name'
            attributes['instrument_attributes'] ||= [{}]
            attributes['instrument_attributes'][0]['title'] = meta.content

          #   description: 'Instrument description',
          elsif meta['key'] == 'instrument_description'
            attributes['instrument_attributes'] ||= [{}]
            attributes['instrument_attributes'][0]['description'] = meta.content

          #   function_1: ['Has a function'],
          elsif meta['key'] == 'instrument_function_tier_1'
            attributes['instrument_attributes'] ||= [{}]
            attributes['instrument_attributes'][0]['function_1'] ||= []
            attributes['instrument_attributes'][0]['function_1'] << meta.content

          #   function_2: ['Has two functions'],
          elsif meta['key'] == 'instrument_function_tier_2'
            attributes['instrument_attributes'] ||= [{}]
            attributes['instrument_attributes'][0]['function_2'] ||= []
            attributes['instrument_attributes'][0]['function_2'] << meta.content

          #   organization: 'Organisation',
          elsif meta['key'] == 'instrument_registered_organization'
            attributes['instrument_attributes'] ||= [{}]
            attributes['instrument_attributes'][0]['instrument_registered_organization'] = meta.content

          #   manufacturer: 'Manufacturer name',
          elsif meta['key'] == 'instrument_manufacturer'
            attributes['instrument_attributes'] ||= [{}]
            attributes['instrument_attributes'][0]['instrument_manufacturer'] = meta.content

          #   complex_person_attributes: [{name: ['Name of operator'], role: ['Operator']}],
          elsif meta['key'] == 'instrument_operator'
            # NOTE this does not actually contain a name, it appears to be an ID like 9999-8888-7777-3210
            # but there is no name to use, and the complex person attributes do not include ID, so this value will be put in as name
            # see https://github.com/antleaf/nims-ngdr-development-2018/blob/master/sample_data_from_msuzuki/AES-narrow/mandatory.xml#L29
            attributes['instrument_attributes'] ||= [{}]
            attributes['instrument_attributes'][0]['complex_person_attributes'] ||= []
            attributes['instrument_attributes'][0]['complex_person_attributes'] << {name: [meta.content], role: ['operator']}

          #   alternative_title: 'An instrument title',
          #   complex_date_attributes: [{date: ['2018-02-14'], description: 'Processed'}],
          #   complex_identifier_attributes: [{identifier: ['123456'], label: ['Local']}],
          # }],
          
          # NOTE that the sample data being used does not appear to have instrument alternative title, dates, or identifiers
          # but it DOES have instrument_type and instrument_registered_department, which are not in the model, so not used
          # ALSO I have checked all the other sample mandatory files and they all contain the same keys

          # complex_specimen_type_attributes: [{
          #   chemical_composition: 'chemical composition',
          #   crystallographic_structure: 'crystallographic structure',
          #   description: 'Description',
          #   complex_identifier_attributes: [{identifier: '1234567'}],
          #   material_types: 'material types',
          #   purchase_record_attributes: [{date: ['2018-02-14'], identifier: ['123456'], purchase_record_item: ['Has a purchase record item'], title: 'Purchase record title'}],
          #   complex_relation_attributes: [{url: 'http://example.com/relation', relationship_role: 'is part of'}],
          #   structural_features: 'structural features',
          #   title: 'Instrument 1'
          # }],
          elsif meta['key'] == 'specimen_process_purchase_date'
            attributes['complex_specimen_type_attributes'] = [ { purchase_record_attributes: [{date: meta.content}] } ]
            
          # NOTE the sample data does not have any of the other complex specimen type fields, 
          # but it DOES have specime_initial_state (note the incorrect spelling) and specimen_final_state
          # neither of which seem to have corresponding keys in the model to insert them into

          # NOTE also that all of the fields below that are defined in our model appear to be missing in 
          # the sample data. At least "title" seems to be mandatory for our model, so it does not seem that any of this data could be acceptable

          # It is also possible that complex_rights_attributes could be used to better represent data_accessibility, which 
          # was inserted above as a simple string, which is what it is provided as in the sample data, such as embargo_till_2019-09-30
          # see: https://github.com/antleaf/nims-ngdr-development-2018/blob/master/sample_data_from_msuzuki/AES-narrow/mandatory.xml#L15
          # BUT as that field is defined only as a String in the sample XML, there is no way to know what format it could appear as
          # in other documents, and also it would be a very brittle way to provide such data when the point of XML is that it could 
          # be provided in more granular fashion. So for now this has not been used, and it is just saved above as a simple string.
          
          # ALSO perhaps relation_attributes would better suit what have been entered above as complex_identifier_attributes
          # but without some way to know what sort of relation a relation_id is meant to be, or what a reference really is, 
          # there is no way to know how to use these relation_attributes for them.
          
          # Lastly, if there is a meta item in the mandatory XML that does not conform to one of the known keys above, 
          # the following else line will cause the import for the data in question to be skipped
          # NOTE that for now this means none of them would succeed, as there are 4 key names described above
          # which do not yet conform to any of our model keys.
          else
            puts 'Mandatory XML file contains an unacceptable key ' + meta['key'] + ' at ' + metadata_filename
            return {}

          # title: ['test dataset'],
          # source: ['Source 1'],
          # keyword: ['keyword 1', 'keyword 2'],
          # language: ['language 1'],
          # publisher: ['publisher 1'],
          # subject: ['subject 1'],
          # properties_addressed: ['chemical -- impurity concentration'],
          # alternative_title: 'Alternative Title',
          # characterization_methods: 'charge distribution',
          # computational_methods: 'computational methods',
          # origin_system_provenance: 'origin system provenance',
          # specimen_set: 'Specimen set',
          # synthesis_and_processing: 'Synthesis and processing methods',
          # complex_rights_attributes: [{date: '1978-10-28', rights: 'CC0'}],
          # complex_version_attributes: [{date: '1978-10-28', description: 'Creating the first version', identifier: 'id1', version: '1.0'}],
          # relation_attributes: [{
          #   title: 'A related item',
          #   url: 'http://example.com/relation',
          #   complex_identifier_attributes: [{identifier: ['123456'], label: ['local']}],
          #   relationship_name: 'Is part of',
          #   relationship_role: 'http://example.com/isPartOf'
          # }],
          # custom_property_attributes: [{label: 'Full name', description: 'My full name is ...'}]

          end
        end

        unless attributes.any?
          puts "Could not extract any metadata from " + metadata_filename
        end
        return attributes
      end
  
      def upload_files(files)
        file_ids = []
        files.each do |file|
          unless File.file?(file)
            # TODO if there are dirs in the file list, perhaps this should zip them instead of ignoreing them
            puts 'Upload dataset are not allowed to include directories within them - only files or zips. Directory ' + file + ' will be ignored'
            next
          end
          u = ::Hyrax::UploadedFile.new
          @current_user = User.batch_user
          u.user_id = @current_user.id unless @current_user.nil?
          u.file = ::CarrierWave::SanitizedFile.new(file)
          u.save
          file_ids << u.id
        end
        return file_ids
      end
  
      def add_work(work_id,attributes,file_ids)
        @object = find_work(work_id)
        if @object
          update_work(@object,attributes,file_ids)
        else
          create_work(attributes,file_ids)
        end
      end

      def find_work(work_id)
        # params[:id] = SecureRandom.uuid unless params[:id].present?
        return find_work_by_id(work_id) if work_id
      end

      def find_work_by_id(work_id)
        @work_klass.find(work_id)
        rescue ActiveFedora::ActiveFedoraError
        nil
      end

      def update_work(@object,attributes,file_ids)
        raise "Object doesn't exist" unless @object
        work_actor.update(environment(update_attributes(attributes,file_ids)))
      end

      def create_work(attributes,file_ids)
        @object = @work_klass.new
        work_actor.create(environment(create_attributes(attributes,file_ids)))
      end

      def create_attributes(attributes,file_ids)
        transform_attributes(attributes,file_ids)
      end

      def update_attributes(attributes,file_ids)
        transform_attributes(attributes,file_ids).except(:id, 'id')
      end

      # @param [Hash] attrs the attributes to put in the environment
      # @return [Hyrax::Actors::Environment]
      def environment(attrs)
        # Set Hyrax.config.batch_user_key
        @current_user = User.batch_user # unless @current_user.present?
        ::Hyrax::Actors::Environment.new(@object, Ability.new(@current_user), attrs)
      end

      def work_actor
        ::Hyrax::CurationConcern.actor
      end

      # Override if we need to map the attributes from the parser in
      # a way that is compatible with how the factory needs them.
      def transform_attributes(attributes,file_ids)
        attributes.merge(file_attributes(file_ids))
      end

      def file_attributes(file_ids)
        file_ids.present? ? { uploaded_files: file_ids } : {}
      end
    end
      
  end
end
      
      
      
      
