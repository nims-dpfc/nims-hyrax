require 'rails_helper'

RSpec.describe ::User do
  let(:user) { described_class.new(username: 'username', display_name: 'Test user') }

  describe '#to_s' do
    subject { user.to_s }
    it { is_expected.to eql 'Test user'}
  end

  describe '#ldap_before_save' do
    before do
      allow(Devise::LDAP::Adapter).to receive(:get_ldap_param).with(user.username, 'mail') { ['email@example.com'] }
      allow(Devise::LDAP::Adapter).to receive(:get_ldap_param).with(user.username, 'cn') { ['Example user'] }
      allow(Devise::LDAP::Adapter).to receive(:get_ldap_param).with(user.username, 'employeeType') { ['A'] }
      allow(Devise).to receive(:friendly_token) { 'password' }
      user.ldap_before_save
    end

    it 'gets the email from ldap' do
      expect(user.email).to eql('email@example.com')
    end

    it 'generates a password' do
      expect(user.password).to eql('password')
    end
  end

  describe 'self.find_or_create_system_user' do
    let!(:existing_user) { create(:user, email: 'existing@example.com') }
    before { allow(Devise).to receive(:friendly_token) { 'password' } }

    context 'finds the existing user' do
      subject { described_class.find_or_create_system_user('existing@example.com') }
      it { is_expected.to eql existing_user}
    end

    context 'creates a new user' do
      subject { described_class.find_or_create_system_user('new@example.com') }
      it { is_expected.to_not eql existing_user}

      it 'sets the username' do
        expect(subject.username).to eql 'new'
      end

      it 'sets the email' do
        expect(subject.email).to eql 'new@example.com'
      end

      it 'sets the password' do
        expect(subject.password).to eql 'password'
      end

      it 'sets the user identifier' do
        expect(subject.user_identifier).to be_present
      end
    end
  end

  describe 'NIMS Roles' do
    let(:user) { described_class.new() }

    describe '#authenticated_nims?' do
      subject { user.authenticated_nims? }
      it { is_expected.to be true }
    end

    describe '#authenticated_external?' do
      subject { user.authenticated_external? }
      it { is_expected.to be true }
    end

    describe '#authenticated?' do
      subject { user.authenticated? }
      it { is_expected.to be true }
    end
  end
end
