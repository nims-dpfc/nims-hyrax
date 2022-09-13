require 'rails_helper'

RSpec.describe Qa::Authorities::Local::FileBasedAuthority do
  authorities = [
    'analysis_fields',
    'characterization_methods',
    'computational_methods',
    'data_origin',
    'dates',
    'material_types',
    'measurement_environments',
    'processing_environments',
    'properties_addressed',
    'roles',
    'structural_features',
    'synthesis_and_processing'
  ]

  authorities.each do |authority|
    describe authority do
      before do
        @la = Qa::Authorities::Local::FileBasedAuthority.new(authority)
      end
      it "has vocabulary for #{authority}" do
        expect(@la.all).not_to be_nil
        expect(@la.all.size).to be > 0
      end
      it "can find a term for #{authority} given the id" do
        @term = @la.all.first
        @term['term'] = @term.delete('label')
        @term.delete('uri')
        expect(@la.find(@term['id'])).to eq(@term)
      end
    end
  end

  describe 'rights_statements' do
    before do
      @la = Qa::Authorities::Local::FileBasedAuthority.new('rights_statements')
    end
    it "has vocabulary for rights_statements" do
      expect(@la.all).not_to be_nil
      expect(@la.all.size).to be > 0
    end
    it "can find a term for rights_statements given the id" do
      @term = @la.all.first
      @term['term'] = @term.delete('label')
      @term.delete('uri')
      expect(@la.find(@term['id'])).to eq(@term)
    end
    it 'has the extra keys in terms hash for rights_statements' do
      @term = @la.all.first
      expect(@term.keys).to include('short_label', 'term', 'label', 'uri', 'human_url')
    end
  end

end
