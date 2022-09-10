require 'rails_helper'

RSpec.describe Hyrax::ResourceSyncController do
  routes { Hyrax::Engine.routes }

  it "should not get source_description" do
    expect {
      get :source_description
    }.to raise_error(ActionController::RoutingError)
  end

  it "should not get capability_list" do
    expect {
      get :capability_list
    }.to raise_error(ActionController::RoutingError)
  end

  it "should not get change_list" do
    expect {
      get :change_list
    }.to raise_error(ActionController::RoutingError)
  end

  it "should not get resource_list" do
    expect {
      get :resource_list
    }.to raise_error(ActionController::RoutingError)
  end
end
