require 'nokogiri'
require 'importers/hyrax_importer'

module Importers
  class DatasetImporter
    attr_reader :import_dir, :metadata_filename

    def initialize(import_dir, metadata_filename='mandatory.xml', debug=false, log_file=nil)
      @import_dir = import_dir
      @metadata_filename = metadata_filename
      @debug = debug
      @log_file = log_file || 'import_dataset.log'
    end

    def perform_create
      return unless dir_exists?(import_dir)

      # for each dir in the import_dir, parse the mandatory.xml file and upload all other files
      # Some examples have measurement.xml, meta.xml, meta_unit.xml - these are not parsed, just treated as files to be uploaded
      Dir.glob(File.join(import_dir, '*')).each do |dir|
        mandatory_fn =  File.join(dir, metadata_filename)
        measurement_fn = File.join(dir, 'measurement.xml')
        next unless file_exists?(mandatory_fn)

        # parse the mandatory metadata file
        attributes = parse_metadata(dir, mandatory_fn, measurement_fn)
        if attributes.blank?
          message = 'Error: No attributes available, skipping import of ' + dir
          write_log(message)
          next
        end

        # list all the files to be uploaded for this item
        files = list_data_files(dir)
        remote_files = []
        # log or import
        if @debug
          write_attributes(dir, attributes)
          write_files(dir, files)
        else
          h = Importers::HyraxImporter.new('Dataset', attributes, files, remote_files)
          h.import
        end
      end
    end

    private
      # Extract metadata and return as attributes
      def parse_metadata(dir, metadata_file, measurement_file)
        attributes = {}
        errors = []
        metadata = File.open(metadata_file) { |f| Nokogiri::XML(f) }

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
        # There are a few errors in other places, e.g. authority files having incorrect spellings.

        # NOTE that in config/authorities, if the field key is in there, the value has to be one of the values in the corresponding file
        # can access those file by their relevant service though, in app/services/ like
        # opts = AnalysisFieldService.new.select_all_options where opts would be a list of lists with values term, id
        # then try to find the term in the list of objects
        # can do AnalysisFieldService.label(VALUE) where label is the term in the yml file
        # but WE DON'T KNOW IF THE VALUES IN THE XML ARE THE IDs OR THE TERMS...
        # if it is not found will throw a key error - in which case do not accept the import at all
        # if it is found, I must replace whatever we do have with the ID value from the authority file

        # All the valid keys of the Dataset attributes are listed below - try to read each into the metadata

        # Set title with the folder title as it does not appear in the meta
        # title: ['test dataset'],
        attributes['title'] = [metadata_file.split('/')[-2]]

        metadata.xpath('//meta').each do |meta|
          # description: ['description 1'],
          if meta['key'] == 'material_description'
            attributes['description'] ||= []
            attributes['description'] << meta.content

          # TODO Anusha to provide info of how to save embargo data - which I will parse out of something like embargo_till_2019-09-30
          # see: https://github.com/antleaf/nims-ngdr-development-2018/blob/master/sample_data_from_msuzuki/AES-narrow/mandatory.xml#L15
          # As that field is defined only as a String in the sample XML, there is no way to know what format it could appear as
          # in other documents, and also it would be a very brittle way to provide such data when the point of XML is that it could
          # be provided in more granular fashion. For now this has been agreed as the approach...
          #elsif meta['key'] == 'data_accessibility'

          # data_origin: ['informatics and data science']
          elsif meta['key'] == 'data_origin'
            attributes['data_origin'] ||= []
            term = DataOriginService.new.find_by_id_or_label(meta.content)
            if term.any?
              attributes['data_origin'] << term['id']
            else
              errors << "#{meta.content} not in data origin authority"
            end

          # complex_identifier_attributes: [{identifier: '0000-0000-0000-0000', scheme: 'uri_of_ORCID_scheme', label: 'ORCID'}],
          elsif meta['key'] == 'data_id' or meta['key'] == 'previous_process_id' or meta['key'] == 'relational_id' or meta['key'] == 'reference'
            attributes['complex_identifier_attributes'] ||= []
            term = IdentifierService.new.find_by_id_or_label(meta['key'])
            if term.any?
              attributes['complex_identifier_attributes'] << {identifier: meta.content, label: term['id']}
            else
              errors << "#{meta['key']} not in identifier authority"
            end

          # complex_date_attributes: [{date: '1978-10-28', description: 'http://purl.org/dc/terms/issued',}],
          # NOTE created and modified are also present in the sample XML, but as all are the same it is not clear if
          # this is data that should be imported into the system or if new created/modified dates relevant to import time
          # should be all that is required (in which case they will be added automatically when the attributes are saved)
          elsif meta['key'] == 'data_registration_date' or meta['key'] == 'processing_data'
            if meta['key'] == 'processing_data'
              desc =  'Processed'
            else
              desc = 'Registered'
            end
            attributes['complex_date_attributes'] ||= []
            attributes['complex_date_attributes'] << {date: meta.content, description: desc}

          # complex_person_attributes: [{
          #   name: 'Foo Bar',
          #   uri: 'http://localhost/person/1234567',
          #   affiliation: 'author affiliation',
          #   role: 'Author',
          #   complex_identifier_attributes: [{identifier: '1234567',scheme: 'Local'}]
          # }],
          elsif meta['key'] == 'entrant'
            # agreed to use Anonymous User and data depositor
            attributes['complex_person_attributes'] ||= [
              {name: 'Anonymous User', role: 'data depositor'}]
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
            attributes['instrument_attributes'][0]['organization'] = meta.content

          #   manufacturer: 'Manufacturer name',
          elsif meta['key'] == 'instrument_manufacturer'
            attributes['instrument_attributes'] ||= [{}]
            attributes['instrument_attributes'][0]['manufacturer'] = meta.content

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

          # specimen_type_attributes: [{
          #   chemical_composition: 'chemical composition',
          #   crystallographic_structure: 'crystallographic structure',
          #   description: 'Description',
          #   complex_identifier_attributes: [{identifier: '1234567'}],
          #   material_types: 'material types',
          #   purchase_record_attributes: [{date: ['2018-02-14'], identifier: ['123456'], purchase_record_item: ['Has a purchase record item'], title: 'Purchase record title'}],
          #   complex_relation_attributes: [{url: 'http://example.com/relation', relationship: 'is part of'}],
          #   structural_features: 'structural features',
          #   title: 'Instrument 1'
          # }],
          elsif meta['key'] == 'specimen_process_purchase_date'
            attributes['specimen_type_attributes'] = [ { purchase_record_attributes: [{date: meta.content}] } ]

          # NOTE the sample data does not have any of the other complex specimen type fields,
          # but it DOES have specime_initial_state (note the incorrect spelling) and specimen_final_state
          # neither of which seem to have corresponding keys in the model to insert them into
          # For now agreed to collate specimen fields into the specimen_set string, and import specime as specimen
          # specimen_set: 'Specimen set',
          elsif meta['key'] == 'specime_initial_state' or meta['key'] == 'specimen_initial_state' or meta['key'] == 'specime_final_state' or meta['key'] == 'specimen_final_state'
            attributes['specimen_set'] ||= ''
            attributes['specimen_set'] += meta['key'] + ':' + meta.content + ';'

          # NOTE also that all of the fields below that are defined in our model appear to be missing in
          # the sample data. At least "title" seems to be mandatory for our model, so it does not seem that any of this data could be acceptable

          # ALSO perhaps relation_attributes would better suit what have been entered above as complex_identifier_attributes
          # but without some way to know what sort of relation a relation_id is meant to be, or what a reference really is,
          # there is no way to know how to use these relation_attributes for them.

          # Lastly, if there is a meta item in the mandatory XML that does not conform to one of the known keys above,
          # the following else line will cause the import for the data in question to be skipped
          # NOTE that for now this means none of them would succeed, as there are 4 key names described above
          # which do not yet conform to any of our model keys.
          else
            # puts 'Mandatory XML file contains an unknown key, which has been imported as a custom property instead: ' + meta['key'] + ' at ' + metadata_file
            # custom_property_attributes: [{label: 'Full name', description: 'My full name is ...'}]
            attributes['custom_property_attributes'] ||= []
            attributes['custom_property_attributes'] << {label: meta['key'], description: meta.content}
            # return {}

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
          # synthesis_and_processing: 'Synthesis and processing methods',
          # complex_rights_attributes: [{date: '1978-10-28', rights: 'CC0'}],
          # complex_version_attributes: [{date: '1978-10-28', description: 'Creating the first version', identifier: 'id1', version: '1.0'}],
          # relation_attributes: [{
          #   title: 'A related item',
          #   url: 'http://example.com/relation',
          #   complex_identifier_attributes: [{identifier: ['123456'], label: ['local']}],
          #   relationship: 'Is part of'
          # }]

          end
        end
        unless attributes.any?
          message = "Error: Could not extract any metadata from " + metadata_file
          write_log(message)
        end
        write_errors(metadata_file, errors) if errors.any?

        # also agreed to parse a measurement.xml file if present, so just do that here for the time being, if it exists in the same folder
        if File.file?(measurement_file)
          measures = File.open(measurement_file) { |f| Nokogiri::XML(f) }
          measures.xpath('//meta').each do |meta|
            # custom_property_attributes: [{label: 'Full name', description: 'My full name is ...'}]
            attributes['custom_property_attributes'] ||= []
            attributes['custom_property_attributes'] << {label: meta['key'], description: meta.content}
          end
        end
        return attributes
      end

      def file_exists?(file_path)
        return true if File.file?(file_path)
        message = 'Error: Mandatory file missing: ' + file_path
        write_log(message)
        false
      end

      def dir_exists?(dir_path)
        return true if File.directory?(dir_path)
        message = 'Error: Diectory missing: ' + dir_path
        write_log(message)
        false
      end

      def list_data_files(dir)
        Dir.glob(File.join(dir, '*')) - [
          File.join(dir, '__METADATA.json'),
          File.join(dir, '__FILES.json')
        ]
      end

      def write_errors(metadata_file, errors)
        message = 'WARN: Metadata errors in file ' + metadata_file
        message += JSON.pretty_generate(errors)
        write_log(message, false)
      end

      def write_attributes(dir, attributes)
        File.open(File.join(dir, '__METADATA.json'),"w") do |f|
          f.write(JSON.pretty_generate(attributes))
        end
      end

      def write_files(dir, files)
        File.open(File.join(dir, '__FILES.json'),"w") do |f|
          f.write(JSON.pretty_generate(files))
        end
      end

      def write_log(message, also_print=true)
        File.open(@log_file, 'w') do |f|
          f.write(message + '\n')
        end
        puts message if also_print
      end
  end
end
