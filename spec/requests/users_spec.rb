require 'rails_helper'

RSpec.describe 'users', type: :request do
  let(:api_key) { create(:api_key) }
  let(:keys) { Base64.encode64("#{api_key.id}:#{api_key.key}") }
  let(:headers) { { 'HTTP_AUTHORIZATION' => "OMGShop #{keys}" } }

  describe '/api/me.get' do
    include_examples 'client auth', '/api/me.get'
    include_examples 'user auth', '/api/me.get'

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

      before { post '/api/me.get', headers: headers }

      it "receives a json with the 'success' root key" do
        expect(json_body['success']).to eq true
      end

      it "receives a json with the 'version' root key" do
        expect(json_body['version']).to eq '1'
      end

      it "receives a json with the 'data' root key" do
        expect(json_body['data']).to eq('object' => 'user',
                                        'id' => user.id.to_s,
                                        'email' => 'john@example.com',
                                        'first_name' => 'John',
                                        'last_name' => 'Doe')
      end
    end
  end

  describe '/api/signup' do
    include_examples 'client auth', '/api/signup'

    context 'user authenticated' do
      let(:api_key) { create(:api_key) }
      let(:keys) { Base64.encode64("#{api_key.id}:#{api_key.key}") }
      let(:headers) { { 'HTTP_AUTHORIZATION' => "OMGShop #{keys}" } }

      context 'with user creation failing in the Wallet API' do
        before do
          allow_any_instance_of(User).to receive(:provider_user_id).and_return(ENV['PROVIDER_USER_ID'])
        end

        let(:params) do
          {
            email: 'john@example.com',
            password: 'password',
            first_name: 'john',
            last_name: 'doe'
          }
        end

        before do
          VCR.use_cassette('user/authenticated/failed_signup') do
            post '/api/signup', headers: headers, params: params
          end
        end

        it 'deletes the user from db' do
          expect(User.count).to eq 0
        end
      end

      context 'with user creation succeeding in the Wallet API' do
        let(:params) do
          {
            email: 'john01@example.com',
            password: 'password',
            first_name: 'john',
            last_name: 'doe'
          }
        end

        before do
          VCR.use_cassette('user/authenticated/signup') do
            post '/api/signup', headers: headers, params: params
          end
        end

        it "receives a json with the 'success' root key" do
          expect(json_body['success']).to eq true
        end

        it "receives a json with the 'version' root key" do
          expect(json_body['version']).to eq '1'
        end

        it "receives a json with the 'data' root key" do
          expect(json_body['data']['object']).to eq('authentication_token')
          expect(json_body['data']['user_id']).to eq(User.last.id.to_s)
          expect(json_body['data']['authentication_token']).not_to eq nil
          expect(json_body['data']['omisego_authentication_token']).not_to eq nil
        end

        it 'creates the user in db' do
          expect(User.last.email).to eq 'john01@example.com'
        end
      end

      context 'when attempting to create a user with an already existing email' do
        let(:params) do
          {
            email: 'john01@example.com',
            password: 'password',
            first_name: 'john',
            last_name: 'doe'
          }
        end

        it 'returns an error' do
          VCR.use_cassette('user/authenticated/signup_duplicate') do
            post '/api/signup', headers: headers, params: params
            expect(json_body['success']).to eq true
            post '/api/signup', headers: headers, params: params
            expect(json_body['success']).to eq false
          end
        end
      end
    end
  end

  describe '/api/me.update' do
    include_examples 'client auth', '/api/me.update'
    include_examples 'user auth', '/api/me.update'

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
          first_name: 'Jane'
        }
      end

      before { post '/api/me.update', headers: headers, params: params }

      it "receives a json with the 'success' root key" do
        expect(json_body['success']).to eq true
      end

      it "receives a json with the 'version' root key" do
        expect(json_body['version']).to eq '1'
      end

      it "receives a json with the 'data' root key" do
        expect(json_body['data']).to eq('object' => 'user',
                                        'id' => user.id.to_s,
                                        'email' => 'john@example.com',
                                        'first_name' => 'Jane',
                                        'last_name' => 'Doe')
      end

      it 'updates the user first name' do
        expect(User.last.first_name).to eq 'Jane'
      end
    end
  end

  describe '/api/me.delete' do
    include_examples 'client auth', '/api/me.delete'
    include_examples 'client auth', '/api/me.delete'

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
          first_name: 'Jane'
        }
      end
      before { post '/api/me.delete', headers: headers }

      it "receives a json with the 'success' root key" do
        expect(json_body['success']).to eq true
      end

      it "receives a json with the 'version' root key" do
        expect(json_body['version']).to eq '1'
      end

      it "receives a json with the 'data' root key" do
        expect(json_body['data']).to eq({})
      end

      it 'updates the user first name' do
        expect(User.where(id: user.id).first).to eq nil
      end
    end
  end
end
