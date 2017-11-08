require 'rails_helper'

RSpec.describe 'access tokens', type: :request do
  let(:api_key) { create(:api_key) }
  let(:keys) { Base64.encode64("#{api_key.id}:#{api_key.key}") }
  let(:headers) { { 'HTTP_AUTHORIZATION' => "OMGBasic #{keys}" } }

  describe '/api/login' do
    include_examples 'client auth', '/api/login'

    context 'authenticated' do
      context 'invalid credentials' do
        before do
          post '/api/login', headers: headers, params: {
            email: 'john@doe.com',
            password: 'password'
          }
        end

        it "receives a json with the 'success' root key" do
          expect(json_body['success']).to eq false
        end

        it 'receives an invalid credentials error' do
          expect(json_body['data']).to eq(
            'object' => 'error',
            'code' => 'client:invalid_credentials',
            'description' => 'Incorrect username/password combination.',
            'messages' => nil
          )
        end
      end

      context 'valid credentials' do
        let(:params) do
          {
            email: 'john@doe.com',
            password: 'password'
          }
        end

        before do
          User.create(params)
          post '/api/login', headers: headers, params: params
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

        it 'receives an auth token back' do
          expect(json_body['data']['object']).to eq('authentication_token')
          expect(json_body['data']['user_id']).to eq(User.last.id.to_s)
          expect(json_body['data']['authentication_token']).not_to eq nil
        end
      end
    end
  end

  describe '/api/logout' do
    include_examples 'client auth', '/api/logout'

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
      let(:headers) { { 'HTTP_AUTHORIZATION' => "OMGAuthenticated #{keys}" } }

      before { post '/api/logout', headers: headers }

      it "receives a json with the 'success' root key" do
        expect(json_body['success']).to eq true
      end

      it "receives a json with the 'version' root key" do
        expect(json_body['version']).to eq '1'
      end

      it "receives a json with the 'data' root key" do
        expect(json_body['data']).to eq({})
      end

      it 'deletes the access token' do
        expect(AccessToken.count).to eq 0
      end
    end
  end
end
