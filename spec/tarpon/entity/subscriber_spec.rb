# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Tarpon::Entity::Subscriber do
  subject { described_class.new(attributes) }

  let(:attributes) do
    {
      entitlements: {}
    }
  end

  describe '#raw' do
    it 'returns the raw attributes without modification' do
      expect(subject.raw).to eq attributes
    end
  end

  describe '#entitlements' do
    let(:entitlements_list) { double('Tarpon::Entity::EntitlementList') }

    before do
      expect(Tarpon::Entity::EntitlementList).to receive(:new)
        .with(attributes[:entitlements])
        .and_return(entitlements_list)
    end

    it 'returns an instance of EntitlementList' do
      expect(subject.entitlements).to eq entitlements_list
    end
  end

  describe '#subscriptions' do
    let(:subscriptions_list) { double('Tarpon::Entity::SubscriptionList') }

    before do
      expect(Tarpon::Entity::SubscriptionList).to receive(:new)
        .with(attributes[:subscriptions])
        .and_return(subscriptions_list)
    end

    it 'returns an instance of SubscriptionList' do
      expect(subject.subscriptions).to eq subscriptions_list
    end
  end
end
