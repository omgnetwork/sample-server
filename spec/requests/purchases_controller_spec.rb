require 'rails_helper'

RSpec.describe 'users', type: :request do
  let(:api_key) { create(:api_key) }
  let(:keys) { Base64.encode64("#{api_key.id}:#{api_key.key}") }
  let(:headers) { { 'HTTP_AUTHORIZATION' => "OMGShop #{keys}" } }
  let(:tshirt_1) { create(:product, name: 'OmiseGO T-Shirt 1') }

  describe '/api/product.buy' do
    include_examples 'client auth', '/api/product.buy'
    include_examples 'user auth', '/api/product.buy'

    context 'user authenticated' do
      let(:user) { create(:user) }
      let(:api_key) { create(:api_key) }
      let(:access_token) do
        token = create(:access_token, user: user, api_key: api_key)
        token.generate_token
      end
      let(:keys) do
        keys_string = "#{api_key.id}:#{api_key.key}"
        tokens_string = "#{user.id}:#{access_token}"
        Base64.encode64("#{keys_string}:#{tokens_string}")
      end
      let(:headers) { { 'HTTP_AUTHORIZATION' => "OMGShop #{keys}" } }
      let(:params) do
        {
          product_id: tshirt_1.id,
          idempotency_key: '123'
        }
      end
      before { post '/api/product.buy', headers: headers, params: params }

      it "receives a json with the 'success' root key" do
        expect(json_body['success']).to eq true
      end

      it "receives a json with the 'version' root key" do
        expect(json_body['version']).to eq '1'
      end

      it "receives a json with the 'data' root key" do
        expect(json_body['data']).to eq({})
      end

      it 'inserts the purchase' do
        purchase = Purchase.last

        expect(purchase).not_to eq nil
        expect(purchase.price).to eq Money.new(1900, 'THB')
        expect(purchase.idempotency_key).to eq '123'
        expect(purchase.product_id).to eq tshirt_1.id
      end
    end
  end
end
