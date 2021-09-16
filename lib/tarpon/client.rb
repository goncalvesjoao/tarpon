# frozen_string_literal: true

require 'tarpon/configuration'

module Tarpon
  class Client
    extend Configuration

    class << self
      def subscriber(app_user_id, config = {})
        Request::Subscriber.new(app_user_id: app_user_id, config: config)
      end

      def receipt(config = {})
        Request::Receipt.new(config: config)
      end
    end
  end
end
