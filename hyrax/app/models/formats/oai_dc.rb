module Formats
  module OaiDc

    FORMAT_OAI_DC = {
      'tag': {
        'name': 'oai_dc:dc',
        'attributes': {
          'xmlns:oai_dc': "http://www.openarchives.org/OAI/2.0/oai_dc/DERP",
          'xmlns:dc': "http://purl.org/dc/elements/1.1/DERP",
          'xmlns:xsi': "http://www.w3.org/2001/XMLSchema-instanceDERP",
          'xsi:schemaLocation': "http://www.openarchives.org/OAI/2.0/oai_dc/ http://www.openarchives.org/OAI/2.0/oai_dc.xsd"
        }
      },
      'fields': {
        'dc:title': Solrizer.solr_name('title', :displayable),
        'dc:creator': Solrizer.solr_name('creator', :displayable),
        'dc:subject': Solrizer.solr_name('subject', :displayable),
        'dc:description': Solrizer.solr_name('description', :displayable),
        'dc:publisher': Solrizer.solr_name('publisher', :displayable),
        'dc:contributor': Solrizer.solr_name('contributor', :displayable),
        'dc:date': Solrizer.solr_name('date_uploaded', :displayable),
        'dc:type': Solrizer.solr_name('resource_type', :displayable),
        'dc:format': Solrizer.solr_name('format', :displayable),
        'dc:identifier': Solrizer.solr_name('id', :displayable),
        'dc:source': Solrizer.solr_name('', :displayable),
        'dc:language': Solrizer.solr_name('language', :displayable),
        'dc:relation': Solrizer.solr_name('', :displayable),
        'dc:coverage': Solrizer.solr_name('', :displayable),
        'dc:rights': Solrizer.solr_name('rights_statement', :displayable)
      }
=begin
      'fields': {
        'dc:title': 'title_tesim',
        'dc:creator': '',
        'dc:subject': 'subject_topic_ssm',
        'dc:description': 'description_ssm',
        'dc:publisher': 'publisher_ssm',
        'dc:contributor': '',
        'dc:date': 'date_issued_ssm',
        'dc:type': 'type_of_resource_ssm',
        'dc:format': 'content_format_ssm',
        'dc:identifier': 'id',
        'dc:source': '',
        'dc:language': 'language_text_ssm',
        'dc:relation': '',
        'dc:coverage': '',
        'dc:rights': 'rights_ssm'
    }
=end
    }

    def export_as_oai_dc_xml
      xml = Builder::XmlMarkup.new
      format = FORMAT_OAI_DC

      xml.tag!(format[:'tag'][:'name'], format[:'tag'][:'attributes']) do
        format[:'fields'].each do |field, mapping|
          process_mapping(xml, field, mapping)
        end
      end
      xml.target!
    end

  end
end
