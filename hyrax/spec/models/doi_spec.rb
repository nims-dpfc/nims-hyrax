require 'rails_helper'

RSpec.describe DOI do
  let(:doi) { described_class.new(value) }

  shared_examples 'doi' do
    context 'url' do
      subject { doi.url }
      it { is_expected.to eql('https://doi.org/10.5555/12345678') }
    end

    context 'label' do
      subject { doi.label }
      it { is_expected.to eql('doi:10.5555/12345678') }
    end

    context 'identifier' do
      subject { doi.identifier }
      it { is_expected.to eql('10.5555/12345678') }
    end
  end

  context 'http:// prefix' do
    context 'with dx.' do
      let(:value) { 'http://dx.doi.org/10.5555/12345678' }
      it_behaves_like 'doi'
    end
    context 'without dx.' do
      let(:value) { 'http://doi.org/10.5555/12345678' }
      it_behaves_like 'doi'
    end
  end

  context 'https:// prefix' do
    context 'with dx.' do
      let(:value) { 'https://dx.doi.org/10.5555/12345678' }
      it_behaves_like 'doi'
    end
    context 'without dx.' do
      let(:value) { 'https://doi.org/10.5555/12345678' }
      it_behaves_like 'doi'
    end
  end

  context 'doi: prefix' do
    context 'with whitespace' do
      let(:value) { 'doi: 10.5555/12345678' }
      it_behaves_like 'doi'
    end
    context 'without whitespace' do
      let(:value) { 'doi:10.5555/12345678' }
      it_behaves_like 'doi'
    end
  end

  context 'info:doi/ prefix' do
    context 'with whitespace' do
      let(:value) { 'info: doi/10.5555/12345678' }
      it_behaves_like 'doi'
    end
    context 'without whitespace' do
      let(:value) { 'info:doi/10.5555/12345678' }
      it_behaves_like 'doi'
    end
  end

  context 'no prefix' do
    let(:value) { '10.5555/12345678' }
    it_behaves_like 'doi'
  end
end
