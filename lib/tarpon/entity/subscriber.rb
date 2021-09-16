# frozen_string_literal: true

module Tarpon
  module Entity
    class Subscriber
      attr_reader :raw, :entitlements, :subscriptions

      def initialize(attributes = {})
        @raw          = attributes
        @entitlements = EntitlementList.new(attributes[:entitlements])
        @subscriptions = SubscriptionList.new(attributes[:subscriptions])
      end

      def active_subscription
        @active_subscription ||= @subscriptions.most_recent_active
      end

      def active_entitlement
        @active_entitlement ||= @entitlements.most_recent_active
      end
    end
  end
end
