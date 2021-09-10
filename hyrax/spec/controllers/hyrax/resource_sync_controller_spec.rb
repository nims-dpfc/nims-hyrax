require 'rails_helper'

RSpec.describe Hyrax::ResourceSyncController do
  routes { Hyrax::Engine.routes }

  it "should not get source_description" do
    get :source_description
    expect(response).to be_not_found
  end

  it "should not get capability_list" do
    get :capability_list
    expect(response).to be_not_found
  end

  it "should not get change_list" do
    get :change_list
    expect(response).to be_not_found
  end

  it "should not get resource_list" do
    get :resource_list
    expect(response).to be_not_found
  end
end
