# frozen_string_literal: true

require 'test_helper'

module UnifiedSettings
  module Handlers
    class CredentialsTest < ActiveSupport::TestCase
      test 'can check if setting is defined: case insesitive' do
        handler = Credentials.new

        Rails.application.credentials.credential_handler_test_key_1 = 'test'
        key = 'credential_handler_test_key_1'

        assert handler.defined?(key)
        assert handler.defined?(key.upcase)

        Rails.application.credentials.pop(key)
      end

      test 'can check if setting is defined: case sesitive' do
        handler = Credentials.new

        Rails.application.credentials.credential_handler_test_key_2 = 'test'
        key = 'credential_handler_test_key_2'

        assert handler.defined?(key, case_sensitive: true)
        refute handler.defined?(key.upcase, case_sensitive: true)

        Rails.application.credentials.pop(key)
      end

      test 'can check if setting is defined: key valus is false' do
        handler = Credentials.new

        Rails.application.credentials.credential_handler_test_key_3 = false
        key = 'credential_handler_test_key_3'

        assert handler.defined?(key)
        assert handler.defined?(key.upcase, case_sensitive: false)

        Rails.application.credentials.pop(key)
      end

      test 'can get setting: case insensitive' do
        handler = Credentials.new

        Rails.application.credentials.credential_handler_test_key_4 = 'test'
        key = 'credential_handler_test_key_4'

        assert_equal \
          Rails.application.credentials.credential_handler_test_key_4,
          handler.get(key)
        assert_equal \
          Rails.application.credentials.credential_handler_test_key_4,
          handler.get(key.upcase)

        Rails.application.credentials.pop(key)
      end

      test 'can get setting: case sensitive' do
        handler = Credentials.new

        Rails.application.credentials.credential_handler_test_key_5 = 'test'
        key = 'credential_handler_test_key_5'

        assert_equal \
          Rails.application.credentials.credential_handler_test_key_5,
          handler.get(key, case_sensitive: true)
        assert_nil handler.get(key.upcase, case_sensitive: true)

        Rails.application.credentials.pop('credential_handler_test_key_5')
      end

      test 'can get setting: key value is false' do
        handler = Credentials.new

        Rails.application.credentials.credential_handler_test_key_5 = false
        key = 'credential_handler_test_key_5'

        assert_equal \
          Rails.application.credentials.credential_handler_test_key_5,
          handler.get(key, case_sensitive: true)
        assert_equal \
          Rails.application.credentials.credential_handler_test_key_5,
          handler.get(key.upcase, case_sensitive: false)

        Rails.application.credentials.pop('credential_handler_test_key_5')
      end
    end
  end
end
