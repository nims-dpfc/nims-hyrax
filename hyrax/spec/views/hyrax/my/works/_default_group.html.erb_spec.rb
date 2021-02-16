require 'rails_helper'

RSpec.describe 'hyrax/my/works/_default_group.html.erb', type: :view do

  let(:id) { "3197z511f" }
  let(:work_data) do
    {
      id: id,
      "has_model_ssim" => ["Dataset"],
      "title_tesim" => ["Work Title"]
    }
  end

  let(:doc) { SolrDocument.new(work_data) }
  let(:docs) { [doc] }
  let(:collection) { mock_model(Collection) }
  let(:presenter) { Hyrax::WorkShowPresenter.new(doc, nil) }

  before do
    def view.render_check_all
    end

    allow(view).to receive(:render_thumbnail_tag).with(doc, { class: "hidden-xs file_listing_thumbnail" }, { suppress_link: true }).and_return("thumbnail")
    allow(view).to receive(:render_check_all).and_return("")
    stub_template 'hyrax/my/works/_work_action_menu.html.erb' => 'actions'
    render 'hyrax/my/works/default_group', docs: docs
  end

  it 'should show status' do
    expect(rendered).to have_css 'th', text: 'Status'
    expect(rendered).not_to have_css 'th', text: 'Highlighted'
  end
end
