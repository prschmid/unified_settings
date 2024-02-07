# frozen_string_literal: true

require 'test_helper'

module UnifiedSettings
  module Handlers
    class CredentialsTest < ActiveSupport::TestCase
      test 'can check if setting is defined: case insesitive' do
        handler = Credentials.new
        key = 'test_credential_1'

        assert handler.defined?(key)
        assert handler.defined?(key.upcase)
      end

      test 'can check if setting is defined: case sesitive' do
        handler = Credentials.new
        key = 'test_credential_1'

        assert handler.defined?(key, case_sensitive: true)
        refute handler.defined?(key.upcase, case_sensitive: true)
      end

      test 'can check if setting is defined: key valus is false' do
        handler = Credentials.new
        key = 'test_credential_1'

        assert handler.defined?(key)
        assert handler.defined?(key.upcase, case_sensitive: false)
      end

      test 'can get setting: case insensitive' do
        handler = Credentials.new
        key = 'test_credential_1'

        assert_equal \
          Rails.application.credentials.test_credential_1,
          handler.get(key)
        assert_equal \
          Rails.application.credentials.test_credential_1,
          handler.get(key.upcase)
      end

      test 'can get setting: case sensitive' do
        handler = Credentials.new
        key = 'test_credential_1'

        assert_equal \
          Rails.application.credentials.test_credential_1,
          handler.get(key, case_sensitive: true)
        assert_nil handler.get(key.upcase, case_sensitive: true)

        Rails.application.credentials.pop('test_credential_1')
      end

      test 'can get setting: key value is false' do
        handler = Credentials.new
        key = 'test_credential_2'

        assert_equal \
          Rails.application.credentials.test_credential_2,
          handler.get(key, case_sensitive: true)
        assert_equal \
          Rails.application.credentials.test_credential_2,
          handler.get(key.upcase, case_sensitive: false)
      end
    end
  end
end
