require 'rails_helper'

RSpec.describe 'users', type: :request do
  let(:api_key) { create(:api_key) }
  let(:keys) { Base64.encode64("#{api_key.id}:#{api_key.key}") }
  let(:headers) { { 'HTTP_AUTHORIZATION' => "OMGShop #{keys}" } }
  let(:tshirt_1) { create(:product, name: 'OmiseGO T-Shirt 1') }

  before do
    allow_any_instance_of(User).to receive(:provider_user_id).and_return('OMGShop/test')
  end

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

      context 'credit' do
        context 'with valid params' do
          let(:params) do
            {
              product_id: tshirt_1.id,
              idempotency_key: '123',
              token_symbol: 'OMG',
              token_value: 0
            }
          end

          before do
            VCR.use_cassette('product/authenticated/buy/credit/valid') do
              post '/api/product.buy', headers: headers, params: params
            end
          end

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
            expect(purchase.status).to eq 'confirmed'
            expect(purchase.price).to eq Money.new(1900, 'THB')
            expect(purchase.idempotency_key).to eq '123'
            expect(purchase.product_id).to eq tshirt_1.id
          end
        end
      end

      context 'debit' do
        context 'with invalid params' do
          let(:params) do
            {
              product_id: tshirt_1.id,
              idempotency_key: '123',
              token_symbol: 'OMG',
              token_value: 100_000_000
            }
          end

          before do
            VCR.use_cassette('product/authenticated/buy/debit/invalid') do
              post '/api/product.buy', headers: headers, params: params
            end
          end

          it "receives a json with the 'success' root key" do
            expect(json_body['success']).to eq false
          end

          it "receives a json with the 'version' root key" do
            expect(json_body['version']).to eq '1'
          end

          it "receives a json with the 'data' root key" do
            expect(json_body['data']).to eq(
              'object' => 'error',
              'code' => 'client:invalid_parameter',
              'description' => 'client:insufficient_funds - The specified balance ' \
                               '(c0d9591e-9d54-4f76-b7aa-666b4666bcc8) does not contain ' \
                               'enough funds. Available: 3780 OMG - Attempted debit: ' \
                               '100000000 OMG',
              'messages' => nil
            )
          end

          it 'inserts the purchase' do
            purchase = Purchase.last

            expect(purchase).not_to eq nil
            expect(purchase.status).to eq 'rejected'
            expect(purchase.price).to eq Money.new(1900, 'THB')
            expect(purchase.idempotency_key).to eq '123'
            expect(purchase.product_id).to eq tshirt_1.id
          end
        end

        context 'with valid params' do
          let(:params) do
            {
              product_id: tshirt_1.id,
              idempotency_key: '123',
              token_symbol: 'OMG',
              token_value: 10
            }
          end

          before do
            VCR.use_cassette('product/authenticated/buy/debit/valid') do
              post '/api/product.buy', headers: headers, params: params
            end
          end

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
            expect(purchase.status).to eq 'confirmed'
            expect(purchase.price).to eq Money.new(1900, 'THB')
            expect(purchase.idempotency_key).to eq '123'
            expect(purchase.product_id).to eq tshirt_1.id
          end
        end
      end
    end
  end
end
