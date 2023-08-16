Rails.configuration.to_prepare do
  fedora_url = ENV.fetch('FEDORA_URL','https://ora4-qa-dps-witness.bodleian.ox.ac.uk/fcrepo/rest')
  ldp_connection = Ldp::Client.new(fedora_url)
  ldp_connection.http.basic_auth(ENV.fetch('FEDORA_USERNAME', 'ora'), ENV.fetch('FEDORA_PASSWORD', 'orapass'))
  Valkyrie::StorageAdapter.register(
    Valkyrie::Storage::Fedora.new(
      connection: ldp_connection,
      fedora_version: 6
    ),
    :fedora6
  )

  Valkyrie::Storage::Fedora.class_eval do
    def upload(file:, original_filename:, resource:, content_type: "application/octet-stream", # rubocop:disable Metrics/ParameterLists
      resource_uri_transformer: default_resource_uri_transformer, **_extra_arguments)
      identifier =  if resource.is_a?(FileSet)
                      resource_uri_transformer.call(resource.parent, base_url) + "/#{resource.original_file.id.split('/').last}"
                    else
                      resource_uri_transformer.call(resource, base_url) + "/#{original_filename}"
                    end

      sha1 = [5, 6].include?(fedora_version) ? "sha" : "sha1"

      connection.http.put do |request|
        request.url identifier
        request.headers['Content-Type'] = content_type
        request.headers['Content-Disposition'] = "attachment; filename=\"#{original_filename}\""
        request.headers['Content-Length'] = file.size.to_s
        request.headers['digest'] = "#{sha1}=#{Digest::SHA1.hexdigest(file)}"
        request.headers['link'] = "<http://www.w3.org/ns/ldp#NonRDFSource>; rel=\"type\""
        request.body = file
      end

      find_by(id: Valkyrie::ID.new(identifier.to_s.sub(/^.+\/\//, ENV.fetch('DPS_FEDORA_URL_SCHEME', 'fedora://'))))
    end
  end
end