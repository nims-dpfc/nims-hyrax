Rails.application.routes.draw do
        mount BrowseEverything::Engine => '/browse'
  mount Riiif::Engine => 'images', as: :riiif if Hyrax.config.iiif_image_server?
  # This needs to appear before Hyrax's routes else sign_in and sign_out break
  devise_for :users, controllers: {sessions: 'users/sessions'}

  authenticate :user, lambda { |u| u.admin? } do
    require 'sidekiq/web'
    mount Sidekiq::Web => '/sidekiq'
  end

  mount Qa::Engine => '/authorities'
  mount Blacklight::Engine => '/'
  mount Hydra::RoleManagement::Engine => '/'
  mount Hyrax::Engine, at: '/'

  concern :exportable, Blacklight::Routes::Exportable.new
  concern :searchable, Blacklight::Routes::Searchable.new

  curation_concerns_basic_routes

  resources :bookmarks do
    concerns :exportable
    collection do
      delete 'clear'
    end
  end

  resource :catalog, only: [:index], as: 'catalog', path: '/catalog', controller: 'catalog' do
    concerns :searchable
  end

  resources :solr_documents, only: [:show], path: '/catalog', controller: 'catalog' do
    concerns :exportable
  end

  resources :welcome, only: 'index'
  root 'hyrax/homepage#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
