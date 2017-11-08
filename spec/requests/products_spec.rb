# spec/requests/books_spec.rb
require 'rails_helper'

RSpec.describe 'products', type: :request do
  let(:api_key) { create(:api_key) }
  let(:keys) { Base64.encode64("#{api_key.id}:#{api_key.key}") }
  let(:headers) { { 'HTTP_AUTHORIZATION' => "OMGShop #{keys}" } }

  let(:tshirt_1) { create(:product, name: 'OmiseGO T-Shirt 1') }
  let(:tshirt_2) { create(:product, name: 'OmiseGO T-Shirt 2') }
  let(:tshirt_3) { create(:product, name: 'OmiseGO T-Shirt 3') }
  let(:tshirts) { [tshirt_1, tshirt_2, tshirt_3] }

  describe 'GET /api/products.get' do
    include_examples 'client auth', '/api/products.get'

    context 'authenticated' do
      before do
        tshirts
        post '/api/products.get', headers: headers
      end

      it 'gets HTTP status 200' do
        expect(response.status).to eq 200
      end

      it "receives a json with the 'success' root key" do
        expect(json_body['success']).to eq true
      end

      it "receives a json with the 'version' root key" do
        expect(json_body['version']).to eq '1'
      end

      it "receives a json with the 'data' root key" do
        expect(json_body['data']).to_not be nil
      end

      it 'receives all 3 products' do
        expect(json_body['data'].size).to eq 3
      end

      it 'receives 3 formatted products' do
        expect(json_body['data']).to eq [
          {
            'object' => 'product',
            'id' => tshirt_1.id.to_s,
            'name' => 'OmiseGO T-Shirt 1',
            'description' => 'Something cool',
            'image_url' => '',
            'price' => 1900,
            'currency' => 'THB'
          },
          {
            'object' => 'product',
            'id' => tshirt_2.id.to_s,
            'name' => 'OmiseGO T-Shirt 2',
            'description' => 'Something cool',
            'image_url' => '',
            'price' => 1900,
            'currency' => 'THB'
          },
          {
            'object' => 'product',
            'id' => tshirt_3.id.to_s,
            'name' => 'OmiseGO T-Shirt 3',
            'description' => 'Something cool',
            'image_url' => '',
            'price' => 1900,
            'currency' => 'THB'
          }
        ]
      end
    end
  end
end
