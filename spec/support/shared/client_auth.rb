RSpec.shared_examples 'client auth' do |path|
  describe 'unauthenticated' do
    context 'without an auth scheme' do
      before { post path }

      it 'gets HTTP status 200' do
        expect(response.status).to eq 200
      end

      it 'gets status false' do
        expect(json_body['success']).to eq false
      end

      it 'get an invalid scheme error' do
        expect(json_body['data']).to eq(
          'object' => 'error',
          'code' => 'client:invalid_auth_scheme',
          'description' => 'The provided authentication scheme is not supported',
          'messages' => nil
        )
      end
    end

    context 'with an invalid API Key ID' do
      let(:api_key) { create(:api_key) }
      let(:keys) { Base64.encode64("1337:#{api_key.key}") }
      let(:headers) { { 'HTTP_AUTHORIZATION' => "OMGBasic #{keys}" } }

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
          'code' => 'client:invalid_api_key',
          'description' => "The provided API key can't be found or is invalid",
          'messages' => nil
        )
      end
    end

    context 'with an invalid API Key' do
      let(:api_key) { create(:api_key) }
      let(:keys) { Base64.encode64("#{api_key.id}:fake") }
      let(:headers) { { 'HTTP_AUTHORIZATION' => "OMGBasic #{keys}" } }

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
          'code' => 'client:invalid_api_key',
          'description' => "The provided API key can't be found or is invalid",
          'messages' => nil
        )
      end
    end
  end
end
