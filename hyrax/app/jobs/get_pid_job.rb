# Synchronises with the NIMS PID API
require 'net/http'

class GetPIDJob < ApplicationJob
  # @param work [ActiveFedora::Base] the work object

  def perform(work)
    raise('Missing PID_API_URL env var') unless ENV['PID_API_URL'].present?
    raise('Missing PID_API_AUTHORIZATION env var') unless ENV['PID_API_AUTHORIZATION'].present?

    puts "Getting PID for work: #{work.id}"

    work_url = routes.send(work.model_name.singular_route_key + '_url', work.id)

    pidrequest = PIDRequest.new(
        id: work.id,
        localId: work_url,
        creator: { canonicalId: ENV['PID_API_USER_PID'] },
        pidCategory: 'DATA_IDENTIFIER',
        disclosureLevel:'PRIVATE'
    )

    doc = renderer.render(pidrequest, class: { PIDRequest: PIDRequestSerializer })
    response = client.post(ENV['PID_API_URL'], doc.to_json)

    if response.success?
      pid_response = PIDResponseDeserializer.call(JSON.parse(response.body)['data'])
      puts "Got PID for work: #{work.id}: #{pid_response[:canonicalId]}"
      # NB: this appends the PID to any existing identifiers
      work.complex_identifier_attributes = [ { identifier: pid_response[:canonicalId], scheme: ['identifier persistent'] }]
      work.save
    else
      begin
        error_msg = JSON.parse(response.body)
      rescue JSON::ParserError
        error_msg = { body: response.body }
      end

      puts "Error calling PID API (#{response.status}): #{error_msg}"
      raise "Call to PID API failed (#{response.status})"
    end
  end

  private

  def client
    @client ||= Faraday.new(headers: { 'Content-Type': 'application/vnd.api+json', 'Authorization': ENV['PID_API_AUTHORIZATION'] })
  end

  def renderer
    @renderer ||= JSONAPI::Serializable::Renderer.new
  end

  def routes
    @routes ||= Rails.application.routes.url_helpers
  end
end
