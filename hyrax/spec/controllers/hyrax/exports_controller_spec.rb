require 'rails_helper'
require 'devise'

RSpec.describe ExportsController do
  include Devise::Test::ControllerHelpers

  describe '#export' do
    let(:response) { get :export, params: {id: file_set.id} }
    let(:status) { response.status }
    let(:json) { JSON.parse(response.body) }

    context 'no file' do
      let(:file_set) { create(:file_set, :open, content: nil) }
      it 'should return an error' do
        expect(status).to eql(400)
        expect(json['error']).to eql('Unknown or unsupported file type')
      end
    end

    context 'non-csv' do
      let(:file_set) { create(:file_set, :open, content: File.open(fixture_path + '/xml/other.txt')) }
      it 'should return an error' do
        expect(status).to eql(400)
        expect(json['error']).to eql('Unknown or unsupported file type')
      end
    end

    context 'csv' do
      context 'open' do
        let(:file_set) { create(:file_set, :open, content: File.open(fixture_path + '/csv/example.csv')) }
        it 'should return a json export of the CSV file' do
          expect(status).to eql(200)
          expect(json['columns']).to match_array(["Code", "Study_participation", "Census_usually_resident_population_count"])
          expect(json['data']).to match_array([
            ["1", "Full-time study", "1000911"],
            ["2", "Part-time study", "149919"],
            ["4", "Not studying", "3548922"],
            ["7", "Response not identifiable", "0"],
            ["9", "Not stated", "0"],
            ["TotalStated", "Total stated", "4699755"],
            ["Total", "Total", "4699755"]
          ])
          expect(json['total_rows']).to eql(7)
          expect(json['maximum_rows']).to eql(200)
          expect(json['file_name']).to eql("example.csv")
        end
      end

      describe 'authentication' do
        let(:file_set) { create(:file_set, :authenticated, content: File.open(fixture_path + '/csv/example.csv')) }

        context 'unauthenticated' do
          it 'should return an unauthenticated error' do
            expect(status).to eql(401)
          end
        end

        context 'authenticated' do
          let(:user) { create(:user) }
          before do
            sign_in user
          end

          it 'should return success' do
            expect(status).to eql(200)
          end
        end
      end
    end

    context 'tsv' do
      context 'open' do
        let(:file_set) { create(:file_set, :open, content: File.open(fixture_path + '/tsv/example.tsv')) }
        it 'should return a json export of the TSV file' do
          expect(status).to eql(200)
          expect(json['columns']).to match_array(["Code", "Study_participation", "Census_usually_resident_population_count"])
          expect(json['data']).to match_array([
                                                  ["1", "Full-time study", "1000911"],
                                                  ["2", "Part-time study", "149919"],
                                                  ["4", "Not studying", "3548922"],
                                                  ["7", "Response not identifiable", "0"],
                                                  ["9", "Not stated", "0"],
                                                  ["TotalStated", "Total stated", "4699755"],
                                                  ["Total", "Total", "4699755"]
                                              ])
          expect(json['total_rows']).to eql(7)
          expect(json['maximum_rows']).to eql(200)
          expect(json['file_name']).to eql("example.tsv")
        end
      end

      describe 'authentication' do
        let(:file_set) { create(:file_set, :authenticated, content: File.open(fixture_path + '/tsv/example.tsv')) }

        context 'unauthenticated' do
          it 'should return an unauthenticated error' do
            expect(status).to eql(401)
          end
        end

        context 'authenticated' do
          let(:user) { create(:user) }
          before do
            sign_in user
          end

          it 'should return success' do
            expect(status).to eql(200)
          end
        end
      end
    end
  end
end
