Given(/^there (?:are|is) (\d+) (open|authenticated|embargo|lease|restricted) datasets?$/) do |number, access|
  @datasets ||= {}
  @datasets[access] = FactoryBot.create_list(:dataset, number, access.to_sym, :with_description_seq, :with_keyword_seq, :with_subject_seq).each do |obj|
    ActiveFedora::SolrService.add(obj.to_solr)
  end
  ActiveFedora::SolrService.commit
end

Given(/^there is a dataset with:$/) do |table|
  @dataset = FactoryBot.create(:dataset, *table.rows.flatten.map(&:to_sym))
  ActiveFedora::SolrService.add(@dataset.to_solr)
  ActiveFedora::SolrService.commit
end

Given(/^I am on the dataset page$/) do
  visit hyrax_dataset_path(@dataset)
end

When(/^I navigate to the new dataset page$/) do
  visit hyrax.dashboard_path  # /dashboard
  click_link "Works"
  click_link "Add new work"

  # If you generate more than one work uncomment these lines
  choose "payload_concern", option: "Dataset"
  click_button "Create work"

  # small hack to skip to create dataset page without requiring javascript
  visit new_hyrax_dataset_path
end

When /^I try to navigate to the new dataset page$/ do
  visit new_hyrax_dataset_path
end

When(/^I navigate to the dataset catalog page$/) do
  visit root_path
  click_link 'Browse all datasets'
  # visit search_catalog_path('f[human_readable_type_sim][]' => 'Dataset')
end

When(/^I create the dataset with:$/) do |table|
  values = table.hashes.first # table is a table.hashes.keys # => [:TITLE, :DATA_ORIGIN, :CREATOR, :KEYWORD]

  expect(page).to have_content /Add New Dataset/i

  click_link "Files" # switch tab
  expect(page).to have_content /Add files/i
  expect(page).to have_content /Add folder/i
  within('span#addfiles') do
    attach_file("files[]", File.join(fixture_path,  'image.jp2'), visible: false)
    attach_file("files[]", File.join(fixture_path, 'jp2_fits.xml'), visible: false)
  end

  click_link "Descriptions" # switch tab
  fill_in('Title', with: values[:TITLE])
  select(values[:DATA_ORIGIN], from: 'Data origin')
  fill_in('dataset[complex_person_attributes][0][name][]', with: values[:CREATOR])
  fill_in('Keyword', with: values[:KEYWORD])
  select('Creative Commons BY-SA Attribution-ShareAlike 4.0 International', from: 'dataset[rights_statement][]')

  # With selenium and the chrome driver, focus remains on the
  # select box. Click outside the box so the next line can't find
  # its element
  find('body').click
  choose('dataset_visibility_open')
  expect(page).to have_content('Please note, making something visible to the world (i.e. marking this as MDR Open) may be viewed as publishing which could impact your ability to')
  check('agreement')

  click_on('Save')

  expect(page).to have_content(values[:TITLE])
end

When(/^I create a draft dataset with:$/) do |table|
  values = table.hashes.first # table is a table.hashes.keys # => [:TITLE, :DATA_ORIGIN, :CREATOR, :KEYWORD]

  expect(page).to have_content /Add New Dataset/i

  click_link "Files" # switch tab
  expect(page).to have_content /Add files/i
  expect(page).to have_content /Add folder/i
  within('span#addfiles') do
    attach_file("files[]", File.join(fixture_path,  'image.jp2'), visible: false)
    attach_file("files[]", File.join(fixture_path, 'jp2_fits.xml'), visible: false)
  end

  click_link "Descriptions" # switch tab
  fill_in('Title', with: values[:TITLE])
  select(values[:DATA_ORIGIN], from: 'Data origin')
  fill_in('dataset[complex_person_attributes][0][name][]', with: values[:CREATOR])
  fill_in('Keyword', with: values[:KEYWORD])
  find('#dataset_rights_statement').select('MIT License')

  # With selenium and the chrome driver, focus remains on the
  # select box. Click outside the box so the next line can't find
  # its element
  find('body').click
  choose('dataset_visibility_open')
  expect(page).to have_content('Please note, making something visible to the world (i.e. marking this as MDR Open) may be viewed as publishing which could impact your ability to')
  check('agreement')

  click_on('Save Draft')

  expect(page).to have_content(values[:TITLE])
end

Then("the dataset can be submitted for approval") do
  dataset = Dataset.last
  visit edit_hyrax_dataset_path(dataset)
  # Go through all required fields and ensure they are all populated
  Hyrax::DatasetForm.required_fields.each do |required_input|
    input_name = "#dataset_" + required_input.to_s
    form_field = find(input_name)
    next if !!form_field.value
    raise "missing required field: #{required_input}"
  end
  find('#with_files_submit').click
  dataset.reload
  workflow_state = dataset.to_sipity_entity.reload.workflow_state_name
  expect(workflow_state).to eq "pending_review"
end

Then(/^I should see the (open|authenticated|embargo|lease|restricted) datasets?$/) do |access|
  # first, verify @datasets is present and has some data
  expect(@datasets[access]).to be_present

  # next, verify there is a link to each dataset (using a regular expression to allow for the locale parameter)
  @datasets[access].each do |dataset|
    expect(page).to have_link(dataset.title.first, href: Regexp.new(hyrax_dataset_path(dataset)))
  end
end

Then(/^I should not see the (open|authenticated|embargo|lease|restricted) datasets?$/) do |access|
  # first, verify @datasets is present and has some data
  expect(@datasets[access]).to be_present

  # next, verify there is a link to each dataset (using a regular expression to allow for the locale parameter)
  @datasets[access].each do |dataset|
    expect(page).to_not have_link(dataset.title.first, href: Regexp.new(hyrax_dataset_path(dataset)))
  end
end

Then(/^I should see only the public metadata of the (open|authenticated|embargo|lease|restricted) datasets?$/) do |access|
  # first, verify @datasets is present and has some data
  expect(@datasets[access]).to be_present

  @datasets[access].each do |dataset|
    # check public metadata is visible
    [:subject, :keyword].each do |field|
      expect(page).to have_css('div.metadata dl dt', text: Regexp.new(field.to_s, Regexp::IGNORECASE))
      expect(page).to have_css('div.metadata dl dd', text: dataset.send(field).first)
    end

    # check restricted metadata is not visible
    [:description].each do |field|
      expect(page).not_to have_css('div.metadata dl dt', text: Regexp.new(field.to_s, Regexp::IGNORECASE))
      expect(page).not_to have_css('div.metadata dl dd', text: dataset.send(field).first)
    end
  end
end

Then(/^I should see both the public and restricted metadata of the (open|authenticated|embargo|lease|restricted) datasets?$/) do |access|
  # first, verify @datasets is present and has some data
  expect(@datasets[access]).to be_present

  @datasets[access].each do |dataset|
    # check public and restricted metadata is visible
    [:description, :subject, :keyword].each do |field|
      expect(page).to have_css('div.metadata dl dt', text: Regexp.new(field.to_s, Regexp::IGNORECASE))
      expect(page).to have_css('div.metadata dl dd', text: dataset.send(field).first)
    end
  end
end

Then(/^I should see the following links to datasets:$/) do |table|
  table.symbolic_hashes.each do |row|
    expect(page).to have_link(row[:label], href: Regexp.new(Regexp.quote(row[:href])))
  end
end
