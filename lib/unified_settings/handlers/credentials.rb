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
        return val unless val.nil?
        return nil if case_sensitive

        val = Rails.application.credentials.dig(*key_arr.map(&:downcase))
        return val unless val.nil?

        Rails.application.credentials.dig(*key_arr.map(&:upcase))
      end

      protected

      def nested_key_exists?(hash, keys)
        if Rails.gem_version < Gem::Version.new('7.1.0')
          super
        else
          return false if hash.nil?

          # Rails 7.1 adds a key? method and so we need to get the config
          # out of the credential object so that it can be treated as a hash
          #  https://github.com/rails/rails/blob/v7.1.1/activesupport/lib/active_support/encrypted_file.rb#L58-L60
          current_level = hash.config
          keys.each do |key|
            return false if current_level.nil?
            return true if current_level.key?(key)

            current_level = current_level[key]
          end

          false
        end
      end
    end
  end
end
