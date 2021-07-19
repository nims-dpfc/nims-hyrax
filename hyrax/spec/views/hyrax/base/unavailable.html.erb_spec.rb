RSpec.describe 'hyrax/base/unavailable.html.erb', type: :view do
  let(:model) do
    double('model',
           persisted?: true,
           to_param: '123',
           model_name: Dataset.model_name)
  end
  let(:workflow_presenter) do
    double('workflow_presenter',
           badge: '<span class="label label-primary state state-deposited">really deposited</span>')
  end
  let(:presenter) do
    double('presenter',
           to_s: 'super cool',
           workflow: workflow_presenter,
           human_readable_type: 'Generic Work')
  end
  let(:parent_presenter) do
    double('parent_presenter',
           to_s: 'parental remark',
           to_model: model,
           human_readable_type: 'Foo Bar')
  end

  before do
    assign(:presenter, presenter)
    assign(:parent_presenter, parent_presenter)
    render
  end
  it "renders with page" do
    expect(rendered).not_to have_content 'super cool'
    expect(rendered).not_to have_content 'really deposited'
    expect(rendered).not_to have_content 'parental remark'
    expect(rendered).not_to have_content 'Generic Work'
    expect(rendered).to eq "<!-- forbidden -->\n"
  end
end
