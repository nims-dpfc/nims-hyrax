require 'rails_helper'

RSpec.describe Handle do
  let(:handle) { described_class.new(value) }

  shared_examples 'handle' do
    context 'url' do
      subject { handle.url }
      it { is_expected.to eql('https://hdl.handle.net/4263537/400') }
    end

    context 'label' do
      subject { handle.label }
      it { is_expected.to eql('hdl:4263537/400') }
    end

    context 'identifier' do
      subject { handle.identifier }
      it { is_expected.to eql('4263537/400') }
    end
  end

  context 'http:// prefix' do
    let(:value) { 'http://hdl.handle.net/4263537/400' }
    it_behaves_like 'handle'
  end

  context 'https:// prefix' do
    let(:value) { 'https://hdl.handle.net/4263537/400' }
    it_behaves_like 'handle'
  end

  context 'hdl: prefix' do
    context 'with whitespace' do
      let(:value) { 'hdl: 4263537/400' }
      it_behaves_like 'handle'
    end
    context 'without whitespace' do
      let(:value) { 'hdl:4263537/400' }
      it_behaves_like 'handle'
    end
  end

  context 'info:hdl/ prefix' do
    context 'with whitespace' do
      let(:value) { 'info: hdl/4263537/400' }
      it_behaves_like 'handle'
    end
    context 'without whitespace' do
      let(:value) { 'info:hdl/4263537/400' }
      it_behaves_like 'handle'
    end
  end

  context 'no prefix' do
    let(:value) { '4263537/400' }
    it_behaves_like 'handle'
  end
end
