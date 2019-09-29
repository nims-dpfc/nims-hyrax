module Importers
  module ImageImporter
    module Collections
      require 'importers/collection_importer'
      def collections
        {
          'http://imeji.nims.go.jp/imeji/collection/sdZWq3eqN1ivoU60' => {
            id: '2d0752c0-fc37-4773-b764-b79ba0fc3139',
            title: ['Fiber fuse damage'],
            description: ['Top part of damage train left after a sudden shutdown of laser power supply.'],
            related_url: ['http://imeji.nims.go.jp/imeji/collection/sdZWq3eqN1ivoU60/'],
            creator: ['Shin-ichi Todoroki'],
            visibility: 'open'
          },
          'http://imeji.nims.go.jp/imeji/collection/8' => {
            id: '0f252c92-c493-4a69-88c1-6f869ff87d8e',
            title: ['Fiber Fuse Movies'],
            description: ['It looks like a tiny comet, a light-induced breakdown of a silica glass optical fiber. In situ image and fused fibers are presented. See also a YouTube video http://www.youtube.com/watch?v=BVmIgaafERk'],
            related_url: ['http://imeji.nims.go.jp/imeji/collection/8'],
            creator: ['Shin-ichi Todoroki'],
            visibility: 'open'
          },
          'http://imeji.nims.go.jp/imeji/collection/PK_GJp0wrrycetcj' => {
            id: '77e4e495-6046-4c52-9b2c-a1afb84276c1',
            title: [' Fiber fuse damage 2'],
            description: ['Initial part of damage train left after a fiber fuse initiation.'],
            related_url: ['http://imeji.nims.go.jp/imeji/collection/PK_GJp0wrrycetcj'],
            creator: ['Shin-ichi Todoroki'],
            visibility: 'open'
          },
          'http://imeji.nims.go.jp/imeji/collection/DEIKQkLx77W3Jrlc' => {
            id: '74e1cb36-357d-49a0-9e94-56c9213a2cf6',
            title: ['フラーレンナノウィスカー'],
            description: ['フラーレンナノウィスカーの成長写真'],
            related_url: ['http://imeji.nims.go.jp/imeji/collection/DEIKQkLx77W3Jrlc'],
            creator: ['科学情報PF (NIMS科学情報PF)'],
            visibility: 'open'
          },
          'http://imeji.nims.go.jp/imeji/collection/16' => {
            id: 'c8265f76-dc6a-44bd-8b63-4c87f0e3b814',
            title: ['Profile information: Optical emission of Methylene Blue'],
              description: ['Optical emission from Methylene Blue in ethanolic solution (excited by a green (532-nm) laser pointer).'],
            related_url: ['http://imeji.nims.go.jp/imeji/collection/16'],
            creator: [],
            visibility: 'open'
          }
        }
      end

      def create_collections
        collections.each do |url, attributes|
          unless attributes.blank?
            collection = Importers::CollectionImporter.new(attributes, attributes[:id], 'open')
            collection.create_collection
          end
        end
      end

      def index_collections
        collections.each do |url, attributes|
          collection = Collection.find(attributes[:id])
          collection.reindex_extent = Hyrax::Adapters::NestingIndexAdapter::LIMITED_REINDEX
        end
      end
    end
  end
end
