# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'hyrax/base/_member.html.erb', type: :view do
  let(:presenter) { Hyrax::WorkShowPresenter.new(solr_document, ability) }
  let(:solr_document) { SolrDocument.new(attributes) }
  let(:attributes) { { 'has_model_ssim' => ['Publication'], :id => '0r967372b' } }
  let(:ability) { double }
  let(:file_document) { SolrDocument.new(id: '1234', 'has_model_ssim' => ['FileSet']) }
  let(:file_member) { Hyrax::FileSetPresenter.new(file_document, ability) }

  before do
    controller = Hyrax::FileSetsController.new
    def view.contextual_path(member, presenter)
    end

    def view.blacklight_config
      @blacklight_config = controller.blacklight_config
    end

    def view.blacklight_configuration_context
      @blacklight_configuration_context ||= Blacklight::Configuration::Context.new(controller)
    end

    allow(view).to receive(:render_thumbnail_tag).and_return(true)
    allow(view).to receive(:dom_class).with(file_member).and_return('file_set')
    allow(view).to receive(:render_thumbnail_tag).and_return(true)
    allow(ability).to receive(:can?).with(:read, '1234').and_return(true)
    allow(ability).to receive(:can?).with(:edit, '1234').and_return(false)
    allow(ability).to receive(:can?).with(:destroy, '1234').and_return(false)
    allow(ability).to receive(:can?).with(:download, '1234').and_return(true)
    allow(view).to receive(:contextual_path).and_return("/concern/publications/0r967372b")
    allow(file_document).to receive(:file_size).and_return("1024")
    allow(view).to receive(:blacklight_config).and_return(controller.blacklight_config)
  end

  it 'shows its file size' do
    stub_template "hyrax/base/_actions.html.erb" => ""
    render 'hyrax/base/member', presenter: presenter, member: file_member

    expect(rendered).to have_content '1 KB'
  end
end
