# frozen_string_literal: true

module Tarpon
  module Entity
    class EntitlementList
      include Enumerable

      def initialize(entitlements = {})
        @entitlements = entitlements.map { |id, params| Entitlement.new(id, params) }
      end

      def [](index)
        @entitlements[index]
      end

      def active
        @entitlements.select(&:active?)
      end

      def each
        @entitlements.each { |e| yield e }
      end

      def most_recent_active
        most_recent = nil

        active.each do |object|
          next if most_recent && most_recent.purchase_date < object.purchase_date

          most_recent = object
        end

        most_recent
      end
    end
  end
end
