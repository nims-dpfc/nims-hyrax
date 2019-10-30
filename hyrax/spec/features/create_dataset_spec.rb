require 'rails_helper'
include Warden::Test::Helpers

# NOTE: If you generated more than one work, you have to set "js: true"
RSpec.feature 'Create a Dataset', js: false do # NB: change to "js: true" to use Selenium/Firefox capybara driver
  include ActiveJob::TestHelper

  context 'a logged in user' do
    let(:user) do
      User.new({ email: 'test@example.com', username: 'user' }) { |u| u.save(validate: false) }
    end
    let(:admin_set_id) { AdminSet.find_or_create_default_admin_set_id }
    let(:permission_template) { Hyrax::PermissionTemplate.find_or_create_by!(source_id: admin_set_id) }
    let(:workflow) { Sipity::Workflow.create!(active: true, name: 'test-workflow', permission_template: permission_template) }

    before do
      # Create a single action that can be taken
      Sipity::WorkflowAction.create!(name: 'submit', workflow: workflow)

      # Grant the user access to deposit into the admin set.
      Hyrax::PermissionTemplateAccess.create!(
        permission_template_id: permission_template.id,
        agent_type: 'user',
        agent_id: user.user_key,
        access: 'deposit'
      )
      login_as user
    end

    after do
      Warden.test_reset!
    end

    scenario do
      visit '/dashboard'
      click_link "Works"
      click_link "Add new work"

      # If you generate more than one work uncomment these lines
      choose "payload_concern", option: "Dataset"
      click_button "Create work"

      # small hack to skip to create dataset page without requiring javascript
      visit new_hyrax_dataset_path

      expect(page).to have_content /Add New Dataset/i
      click_link "Files" # switch tab
      expect(page).to have_content /Add files/i
      expect(page).to have_content /Add folder/i

      within('span#addfiles') do
        attach_file("files[]", "#{Hyrax::Engine.root}/spec/fixtures/image.jp2", visible: false)
        attach_file("files[]", "#{Hyrax::Engine.root}/spec/fixtures/jp2_fits.xml", visible: false)
      end
      click_link "Descriptions" # switch tab
      fill_in('Title', with: 'My Test Work')
      fill_in('Supervisor', with: 'Professor Jones')
      select('experiments', from: 'Data origin')

      # fill_in('Creator', with: 'Doe, Jane')
      fill_in('dataset[complex_person_attributes][0][name][]', with: 'Doe, Jane')

      fill_in('Keyword', with: 'testing')
      # select('In Copyright', from: 'Rights statement')
      select('Creative Commons BY-SA Attribution-ShareAlike 4.0 International', from: 'dataset[complex_rights_attributes][0][rights][]')

      # With selenium and the chrome driver, focus remains on the
      # select box. Click outside the box so the next line can't find
      # its element
      find('body').click
      choose('dataset_visibility_open')
      expect(page).to have_content('Please note, making something visible to the world (i.e. marking this as Public) may be viewed as publishing which could impact your ability to')
      check('agreement')

      click_on('Save')
      expect(page).to have_content('My Test Work')
      expect(page).to have_content "Your files are being processed by MDR in the background."
    end
  end
end
