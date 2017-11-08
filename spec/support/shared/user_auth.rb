RSpec.shared_examples 'user auth' do |path|
  describe 'unauthenticated' do
    context 'with an invalid auth token' do
      let(:user) { create(:user) }
      let(:api_key) { create(:api_key) }

      let(:keys) do
        keys_string = "#{api_key.id}:#{api_key.key}"
        tokens_string = "#{user.id}:fake"
        Base64.encode64("#{keys_string}:#{tokens_string}")
      end
      let(:headers) { { 'HTTP_AUTHORIZATION' => "OMGShop #{keys}" } }

      before { post path, headers: headers }

      it 'gets HTTP status 200' do
        expect(response.status).to eq 200
      end

      it 'gets status false' do
        expect(json_body['success']).to eq false
      end

      it 'get an invalid scheme error' do
        expect(json_body['data']).to eq(
          'object' => 'error',
          'code' => 'user:invalid_authentication_token',
          'description' => 'There is no user corresponding to the provided auth token',
          'messages' => nil
        )
      end
    end
  end
end
