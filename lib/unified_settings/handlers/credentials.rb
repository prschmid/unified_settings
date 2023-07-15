# frozen_string_literal: true

require_relative 'base'

module UnifiedSettings
  module Handlers
    # Setting handler for Rails.application.credentials
    class Credentials < Base
      def defined?(key, case_sensitive: nil)
        key_arr = to_symbol_array(key)
        case_sensitive = case_sensitive?(case_sensitive)

        return true if nested_key_exists?(Rails.application.credentials,
                                          key_arr)
        return false if case_sensitive

        return true if nested_key_exists?(
          Rails.application.credentials, key_arr.map(&:upcase)
        )
        return true if nested_key_exists?(
          Rails.application.credentials, key_arr.map(&:downcase)
        )

        false
      end

      def get(key, case_sensitive: nil)
        key_arr = to_symbol_array(key)
        case_sensitive = case_sensitive?(case_sensitive)

        val = Rails.application.credentials.dig(*key_arr)
        return val if val
        return nil if case_sensitive

        val = Rails.application.credentials.dig(*key_arr.map(&:downcase))
        return val if val

        Rails.application.credentials.dig(*key_arr.map(&:upcase))
      end
    end
  end
end
