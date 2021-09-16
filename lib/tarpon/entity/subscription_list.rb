# frozen_string_literal: true

module Tarpon
  module Entity
    class SubscriptionList
      include Enumerable

      def initialize(subscriptions = nil)
        subscriptions ||= {}

        @subscriptions = subscriptions.map { |id, params| Subscription.new(id, params) }
      end

      def [](index)
        @subscriptions[index]
      end

      def active
        @subscriptions.select(&:active?)
      end

      def most_recent_active
        most_recent = nil

        active.each do |object|
          next if most_recent && most_recent.purchase_date < object.purchase_date

          most_recent = object
        end

        most_recent
      end

      def each
        @subscriptions.each { |e| yield e }
      end
    end
  end
end
