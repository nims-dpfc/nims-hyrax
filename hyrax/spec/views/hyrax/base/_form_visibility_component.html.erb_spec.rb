RSpec.describe 'hyrax/base/_form_visibility_component.html.erb', type: :view do
  let(:ability) { double }
  let(:user) { stub_model(User) }
  let(:form) do
    Hyrax::DatasetForm.new(work, ability, controller)
  end
  let(:page) do
    view.simple_form_for form do |f|
      render 'hyrax/base/form_visibility_component', f: f
    end
    Capybara::Node::Simple.new(rendered)
  end

  before do
    allow(controller).to receive(:current_user).and_return(user)
    allow(work).to receive(:visibility).and_return('open')
  end

  context "for a new object" do
    before { assign(:form, form) }

    let(:work) { Dataset.new }

    it 'Embargo should be hidden' do
      expect(page).not_to have_content 'Embargo'
    end

    it 'Lease should be hidden' do
      expect(page).not_to have_content 'Lease'
    end
  end
end
