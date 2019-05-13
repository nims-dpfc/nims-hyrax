require 'nokogiri'
require 'importers/hyrax_importer'

module Importers
  module DatasetImporter
    require 'importers/dataset_importer/parse_xml'
    require 'importers/dataset_importer/unpacker'
    require 'importers/dataset_importer/importer'
    require 'importers/dataset_importer/bulk_importer'
  end
end
