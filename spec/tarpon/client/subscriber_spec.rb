# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Tarpon::Client do
  let(:app_user_id) { 'app-user-id' }

  describe '.subscriber' do
    let(:base_call) { described_class.subscriber(app_user_id) }

    describe '.get_or_create' do
      it_behaves_like 'an http call to RevenueCat responding with subscriber object', method: :get, api_key: :public do
        let(:client_call) { [:get_or_create] }
        let(:uri) { "#{described_class.base_uri}/subscribers/#{app_user_id}" }
      end
    end

    describe '.delete' do
      it_behaves_like 'an http call to RevenueCat', method: :delete, api_key: :secret, response: :custom do
        let(:client_call) { [:delete] }
        let(:uri) { "https://api.revenuecat.com/v1/subscribers/#{app_user_id}" }
        let(:response) { JSON.generate(app_user_id: app_user_id) }
        let(:response_expectation) do
          lambda do |r|
            expect(r.raw).to eq(app_user_id: app_user_id)
            expect(r.subscriber).to be_nil
          end
        end
      end
    end

    describe '.entitlements' do
      let(:base_call) { described_class.subscriber(app_user_id).entitlements(entitlement_id) }
      let(:entitlement_id) { 'premium' }

      describe '.grant_promotional' do
        it_behaves_like 'an http call to RevenueCat responding with subscriber object',
                        method: :post, api_key: :secret do
          let(:body) { { duration: 'weekly', start_time_ms: 123 } }
          let(:client_call) { [:grant_promotional, body] }
          let(:uri) do
            "#{described_class.base_uri}/subscribers/#{app_user_id}/entitlements/#{entitlement_id}/promotional"
          end
        end
      end

      describe '.revoke_promotional' do
        it_behaves_like 'an http call to RevenueCat responding with subscriber object',
                        method: :post, api_key: :secret do
          let(:client_call) { [:revoke_promotional] }
          let(:uri) do
            "#{described_class.base_uri}/subscribers/#{app_user_id}/entitlements/#{entitlement_id}/revoke_promotionals"
          end
        end
      end
    end

    describe '.delete' do
      it_behaves_like 'an http call to RevenueCat', method: :delete, api_key: :secret, response: :custom do
        let(:client_call) { [:delete] }
        let(:uri) { "https://api.revenuecat.com/v1/subscribers/#{app_user_id}" }
        let(:response) { JSON.generate(app_user_id: app_user_id) }
        let(:response_expectation) do
          lambda do |r|
            expect(r.raw).to eq(app_user_id: app_user_id)
            expect(r.subscriber).to be_nil
          end
        end
      end
    end

    describe '.offerings' do
      let(:base_call) { described_class.subscriber(app_user_id).offerings }
      let(:platform) { 'ios' }

      it_behaves_like 'an http call to RevenueCat',
                      method: :get, api_key: :public, response: :custom do
        let(:client_call) { [:list, platform] }
        let(:uri) do
          "#{described_class.base_uri}/subscribers/#{app_user_id}/offerings"
        end
        let(:response) do
          File.read('spec/fixtures/offerings.json')
        end
        let(:response_expectation) do
          lambda do |r|
            expect(r.current_offering_id).to eq('standard')
            expect(r[:standard]).not_to be_nil
            expect(r['standard'].packages.first.identifier).to eq('$rc_monthly')
          end
        end
      end
    end

    describe '.subscriptions' do
      let(:base_call) { described_class.subscriber(app_user_id).subscriptions(product_id) }
      let(:product_id) { 'monthly' }

      describe '.defer' do
        it_behaves_like 'an http call to RevenueCat responding with subscriber object',
                        method: :post, api_key: :secret do
          let(:body) { { expiry_time_ms: 123_45 } }
          let(:client_call) { [:defer, body] }
          let(:uri) { "#{described_class.base_uri}/subscribers/#{app_user_id}/subscriptions/#{product_id}/defer" }
        end
      end
    end

    context 'when Client configuration is set' do
      let(:public_api_key) { '666' }
      let(:secret_api_key) { '777' }
      let(:custom_public_api_key) { '999' }

      subject { described_class.subscriber(app_user_id, { public_api_key: custom_public_api_key }) }

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
