require 'rails_helper'

RSpec.describe UserAuthorisationService do
  let(:user) { create(:user) }
  let(:service) { described_class.new(user) }

  context 'without env vars' do
    before do
      allow(ENV).to receive(:[]).with('LDAP_HOST').and_return(nil)
      allow(ENV).to receive(:[]).with('LDAP_BASE').and_return(nil)
      allow(ENV).to receive(:[]).with('LDAP_ATTRIBUTE').and_return(nil)
    end
    it { expect(service.enabled?).to be false }
    it { expect(service.update_attributes).to be false }
  end

  context 'with env vars' do
    before do
      allow(ENV).to receive(:[]).with('LDAP_HOST').and_return('localhost')
      allow(ENV).to receive(:[]).with('LDAP_BASE').and_return('ou=people,dc=test,dc=com')
      allow(ENV).to receive(:[]).with('LDAP_ATTRIBUTE').and_return('uid')
    end
    it { expect(service.enabled?).to be true }

    describe '#update_attributes' do
      let(:entry) { Net::LDAP::Entry.from_single_ldif_string( "dn: user1234\ncn: Alice Bloggs\nmail: newmail@example.com\nemployeeType: Z1234") }
      before do
        allow_any_instance_of(Net::LDAP).to receive(:search).with(base: 'ou=people,dc=test,dc=com', filter: Net::LDAP::Filter.eq('uid', user.username)).and_return([entry])
        service.update_attributes
      end
      it { expect(user.email).to eql('newmail@example.com') }
      it { expect(user.display_name).to eql('Alice Bloggs') }
      it { expect(user.employee_type_code).to eql('Z') }
      it { expect(service.update_attributes).to be true }
    end
  end
end
