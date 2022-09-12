class Resourcesync
  def initialize
    @base_url = URI.parse(ENV['MDR_HOST'] || 'http://localhost:3000').to_s
  end

  def generate_capabilitylist
    capabilitylist = Resync::CapabilityList.new(
      links: [Resync::Link.new(rel: 'up', uri: @base_url)],
      resources: [
        Resync::Resource.new(uri: "#{@base_url}/resourcelist.xml", metadata: Resync::Metadata.new(capability: 'resourcelist')),
        Resync::Resource.new(uri: "#{@base_url}/changelist.xml", metadata: Resync::Metadata.new(capability: 'changelist'))
      ]
    )

    capabilitylist.save_to_xml
  end

  def generate_resourcelist_index
    works = ActiveFedora::Base.search_with_conditions(public_work, sort: ['date_modified_dtsi desc'])
    last_updated = works.first&.date_modified

    resourcelist_index = Resync::ResourceListIndex.new(
      links: [ Resync::Link.new(rel: 'up', uri: "#{@base_url}/capabilitylist.xml") ],
      metadata: Resync::Metadata.new(
        capability: 'resourcelist',
        from_time: from_time
      ),
      resources: (((Dataset.count + Publication.count) / 50000) + 1).times.map do |i|
        Resync::Resource.new(
          uri: URI.parse("#{@base_url}/resourcelist_#{i}.xml").to_s,
          modified_time: Time.zone.now
        )
      end
    )

    resourcelist_index.save_to_xml
  end

  def generate_resourcelist
    xml_lists = []
    last_updated = ActiveFedora::Base.search_with_conditions(public_work, sort: ['date_modified_dtsi desc']).first&.date_modified

    ActiveFedora::Base.search_in_batches(public_work, batch_size: 50000) do |works|
      resourcelist = Resync::ResourceList.new(
        links: [ Resync::Link.new(rel: 'up', uri: URI.parse("#{@base_url}/capabilitylist.xml").to_s) ],
        metadata: Resync::Metadata.new(
          capability: 'resourcelist',
          from_time: from_time
        ),
        resources: works.map{|work|
          Resync::Resource.new(
            uri: Rails.application.routes.url_helpers.polymorphic_url(ActiveFedora::Base.find(work.id), host: @base_url),
            modified_time: work.date_modified
          )
        }
      )

      xml_lists << resourcelist.save_to_xml
    end

    xml_lists
  end

  def generate_changelist_index
    last_updated = ActiveFedora::Base.search_with_conditions(public_work, sort: ['date_modified_dtsi desc']).first&.date_modified

    changelist_index = Resync::ChangeListIndex.new(
      links: [ Resync::Link.new(rel: 'up', uri: URI.parse("#{@base_url}/capabilitylist.xml").to_s) ],
      metadata: Resync::Metadata.new(
        capability: 'changelist',
        from_time: from_time
      ),
      resources: (((Dataset.count + Publication.count) / 50000) + 1).times.map do |i|
        Resync::Resource.new(
          uri: URI.parse("#{@base_url}/changelist_#{i}.xml").to_s,
          modified_time: Time.zone.now
        )
      end
    )

    changelist_index.save_to_xml
  end

  # TODO: add conditions
  def generate_changelist
    xml_lists = []
    last_updated = ActiveFedora::Base.search_with_conditions(public_work, sort: ['date_modified_dtsi desc']).first&.date_modified

    ActiveFedora::Base.search_in_batches(public_work, batch_size: 50000) do |works|
      changelist = Resync::ChangeList.new(
        links: [ Resync::Link.new(rel: 'up', uri: URI.parse("#{@base_url}/capabilitylist.xml").to_s) ],
        metadata: Resync::Metadata.new(
          capability: 'changelist',
          from_time: from_time
        ),
        resources: works.map{|work|
          Resync::Resource.new(
            uri: Rails.application.routes.url_helpers.polymorphic_url(ActiveFedora::Base.find(work.id), host: @base_url),
            modified_time: work.date_modified,
            metadata: Resync::Metadata.new(
              change: Resync::Types::Change::UPDATED,
              # datetime: work.updated_at
            )
          )
        }
      )

      xml_lists << changelist.save_to_xml
    end

    xml_lists
  end

  private

  def public_work
    { has_model_ssim: ["Publication", "Dataset"], workflow_state_name_ssim: "deposited", read_access_group_ssim: "public" }
  end

  def from_time
    ActiveFedora::Base.search_with_conditions(public_work, sort: ['date_uploaded_dtsi asc']).first&.date_modified
  end
end
