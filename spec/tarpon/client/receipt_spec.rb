# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Tarpon::Client do
  let(:app_user_id) { 'app-user-id' }

  describe '.receipt' do
    let(:base_call) { described_class.receipt }

    describe '.create' do
      it_behaves_like 'an http call to RevenueCat responding with subscriber object', method: :post, api_key: :public do
        let(:platform) { 'ios' }
        let(:headers) { { 'X-Platform' => platform } }
        let(:uri) { "#{described_class.base_uri}/receipts" }
        let(:body) do
          {
            app_user_id: app_user_id,
            fetch_token: 'fetch-token'
          }
        end
        let(:client_call) { [:create, platform: platform, **body] }
      end
    end

    context 'when Client configuration is set' do
      let(:public_api_key) { '666' }
      let(:secret_api_key) { '777' }
      let(:custom_public_api_key) { '999' }

      subject { described_class.receipt({ public_api_key: custom_public_api_key }) }

      before do
        Tarpon::Client.public_api_key = public_api_key
        Tarpon::Client.secret_api_key = secret_api_key
      end
      after do
        Tarpon::Client.public_api_key = nil
        Tarpon::Client.secret_api_key = nil
      end

      it 'allows to overwrite Client configuration' do
        expect(subject.send(:get_config, :public_api_key)).to eq custom_public_api_key
        expect(subject.send(:get_config, :secret_api_key)).to eq secret_api_key
      end
    end
  end
end
