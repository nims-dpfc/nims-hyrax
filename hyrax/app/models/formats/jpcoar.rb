require 'builder'

# This module provide JPCOAR export
module Formats
  module Jpcoar

    FORMAT_JPCOAR = {
        'tag': {
            'name': 'jpcoar',
            'attributes': {
                'xmlns:xs' => "http://www.w3.org/2001/XMLSchema",
                'xmlns:dc' => "http://purl.org/dc/elements/1.1/",
                'xmlns:dcterms' => "http://purl.org/dc/terms/",
                'xmlns:rioxxterms' => "http://www.rioxx.net/schema/v2.0/rioxxterms/",
                'xmlns:datacite' => "https://schema.datacite.org/meta/kernel-4/",
                'xmlns:oaire' => "http://namespace.openaire.eu/schema/oaire/",
                'xmlns:dcndl' => "http://ndl.go.jp/dcndl/terms/",
                'xmlns:jpcoar' => "https://github.com/JPCOAR/schema/blob/master/1.0/",
                'xsi:schemaLocation' => "https://github.com/JPCOAR/schema/blob/master/1.0/jpcoar_scm.xsd"
            }
        },
        'fields': {
            'dc:title': Solrizer.solr_name('title', :displayable),
            'dcterms:alternative': Solrizer.solr_name('alternative_title', :displayable),
            'jpcoar:creator': {'function': 'creator'},
            'jpcoar:contributor': {'function': 'contributor'},      # looks very similar to creator
            'dcterms:accessRights': '',
            'rioxxterms:apc': '',
            'dc:rights': Solrizer.solr_name('rights_statement', :displayable),
            'jpcoar:rightsHolder': {'function': 'rights_holder'},
            'jpcoar:subject': 'subject_sim',
            'datacite:description': '',
            'dc:publisher': Solrizer.solr_name('publisher', :displayable),
            'datacite:date': '',
            'dc:language': Solrizer.solr_name('language', :displayable),
            'dc:type': Solrizer.solr_name('resource_type', :displayable),
            'datacite:version': '',
            'oaire:version': '',
            'jpcoar:identifier': '',
            'jpcoar:identifierRegistration': '',
            'jpcoar:relation': '',
            'dcterms:temporal': '',
            'datacite:geoLocation': '',
            'jpcoar:fundingReference': '',
            'jpcoar:sourceIdentifier': '',
            'jpcoar:sourceTitle': '',
            'jpcoar:volume': '',
            'jpcoar:issue': '',
            'jpcoar:numPages': '',
            'jpcoar:pageStart': '',
            'jpcoar:pageEnd': '',
            'dcndl:dissertationNumber': '',
            'dcndl:degreeName': '',
            'dcndl:dateGranted': '',
            'jpcoar:degreeGrantor': '',
            'jpcoar:conference': '',
            'jpcoar:file': '',
        }
    }
    # 'dcterms:isReferencedBy': {'function': 'full_resource_uri'}

    def export_as_jpcoar_xml
      xml = Builder::XmlMarkup.new
      format = FORMAT_JPCOAR

      xml.tag!(format[:'tag'][:'name'], format[:'tag'][:'attributes']) do
        format[:'fields'].each do |field, mapping|
          process_mapping(xml, field, mapping)
        end
      end
      xml.target!
    end

    def to_jpcoar
      export_as('jpcoar_xml')
    end

    def format(field, xml)
      if mime_types.present?
        Array.wrap(mime_types).each do |mime_type|
          xml.tag!(field, mime_type, 'xsi:type' => 'dcterms:IMT')
        end
      end
    end

    def mime_types
      self['content_mime_type_ssm']
    end

    def creator
    end

    def contributor
    end

    def rights_holder
    end



  end
end
