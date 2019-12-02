require 'rails_helper'

RSpec.describe ::User do
  let(:user) { described_class.new(username: 'username') }

  describe '#to_s' do
    subject { user.to_s }
    it { is_expected.to eql 'username'}
  end

  describe '#ldap_before_save' do
    before do
      allow(Devise::LDAP::Adapter).to receive(:get_ldap_param).with(user.username, 'mail') { ['email@example.com'] }
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
    end
  end

  describe 'NIMS Roles' do
    let(:user) { described_class.new(employee_type_code: employee_type_code) }

    describe '#authenticated_nims_researcher?' do
      subject { user.authenticated_nims_researcher? }

      context 'employee_type A' do
        let(:employee_type_code) { 'A' }
        it { is_expected.to be true }
      end

      context 'employee_type G' do
        let(:employee_type_code) { 'G' }
        it { is_expected.to be true }
      end

      context 'employee_type L' do
        let(:employee_type_code) { 'L' }
        it { is_expected.to be true }
      end

      context 'employee_type Q' do
        let(:employee_type_code) { 'Q' }
        it { is_expected.to be true }
      end

      context 'employee_type R' do
        let(:employee_type_code) { 'R' }
        it { is_expected.to be true }
      end

      context 'employee_type S' do
        let(:employee_type_code) { 'S' }
        it { is_expected.to be true }
      end

      context 'employee_type X' do
        let(:employee_type_code) { 'X' }
        it { is_expected.to be false }
      end
    end

    describe '#authenticated_nims_other?' do
      subject { user.authenticated_nims_other? }

      context 'employee_type T' do
        let(:employee_type_code) { 'T' }
        it { is_expected.to be true }
      end

      context 'employee_type Z' do
        let(:employee_type_code) { 'Z' }
        it { is_expected.to be true }
      end

      context 'employee_type X' do
        let(:employee_type_code) { 'X' }
        it { is_expected.to be false }
      end
    end

    describe '#authenticated_nims?' do
      subject { user.authenticated_nims? }

      context 'employee_type A' do
        let(:employee_type_code) { 'A' }
        it { is_expected.to be true }
      end

      context 'employee_type T' do
        let(:employee_type_code) { 'T' }
        it { is_expected.to be true }
      end

      context 'employee_type X' do
        let(:employee_type_code) { 'X' }
        it { is_expected.to be false }
      end
    end

    describe '#authenticated_external?' do
      let(:employee_type_code) { nil }
      subject { user.authenticated_external? }
      it { is_expected.to be false }
    end

    describe '#authenticated?' do
      let(:employee_type_code) { 'A' }
      subject { user.authenticated? }
      it { is_expected.to be true }
    end
  end
end
