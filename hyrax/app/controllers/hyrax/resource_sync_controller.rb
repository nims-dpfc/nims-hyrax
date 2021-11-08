class Hyrax::ResourceSyncController < ApplicationController
  # We don't need locale here
  def default_url_options
    super.except(:locale)
  end

  def source_description
    raise ActionController::RoutingError.new('Not Found')
  end

  def capability_list
    raise ActionController::RoutingError.new('Not Found')
  end

  def change_list
    raise ActionController::RoutingError.new('Not Found')
  end

  def resource_list
    raise ActionController::RoutingError.new('Not Found')
  end
end