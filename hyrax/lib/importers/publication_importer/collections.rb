module Importers
  module PublicationImporter
    module Collections
      require 'importers/collection_importer'

      def collections
        {
          'escidoc_dump_genso.xml' => {
            title: ['Library of Strategic Natural Resources (genso)'],
            id: 'genso'
          },
          'escidoc_dump_materials.xml' => {
            title: ['Materials Science Library'],
            id: '1544bp08d'
          },
          'escidoc_dump_nims_publications.xml' => {
            title: ['NIMS Publications'],
            id: 'fb4948403'
          },
          'escidoc_dump_nnin.xml' => {
            title: ['NNIN collection'],
            id: 'tm70mv16z'
          }
        }
      end

      def get_collection_id
        # create collection
        fn = File.basename(@metadata_file)
        col_attrs = collections.fetch(fn, nil)
        return nil if col_attrs.blank?
        col = Importers::CollectionImporter.new(col_attrs, col_attrs[:id], 'open')
        collection = col.fetch_collection
        return col_attrs[:id] if collection
        nil
      end
    end
  end
end
