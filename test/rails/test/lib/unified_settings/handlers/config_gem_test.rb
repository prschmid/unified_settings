# frozen_string_literal: true

require 'test_helper'

module UnifiedSettings
  module Handlers
    class ConfigGemTest < ActiveSupport::TestCase
      test 'can check if setting is defined: case insesitive' do
        handler = ConfigGem.new

        ::Settings.config_gem_handler_test_key_1 = 'test'
        key = 'config_gem_handler_test_key_1'

        assert handler.defined?(key)
        assert handler.defined?(key.upcase)

        # Doesn't look like we can remove it, so set it to nil
        ::Settings.config_gem_handler_test_key_1 = nil
      end

      test 'can check if setting is defined: case sesitive' do
        handler = ConfigGem.new

        ::Settings.config_gem_handler_test_key_2 = 'test'
        key = 'config_gem_handler_test_key_2'

        assert handler.defined?(key, case_sensitive: true)
        refute handler.defined?(key.upcase, case_sensitive: true)

        # Doesn't look like we can remove it, so set it to nil
        ::Settings.config_gem_handler_test_key_2 = nil
      end

      test 'can check if setting is defined: key value is false' do
        handler = ConfigGem.new

        ::Settings.config_gem_handler_test_key_3 = false
        key = 'config_gem_handler_test_key_3'

        assert handler.defined?(key)
        assert handler.defined?(key.upcase, case_sensitive: false)

        # Doesn't look like we can remove it, so set it to nil
        ::Settings.config_gem_handler_test_key_3 = nil
      end

      test 'can get setting: case insensitive' do
        handler = ConfigGem.new

        ::Settings.config_gem_handler_test_key_4 = 'test'
        key = 'config_gem_handler_test_key_4'

        assert_equal ::Settings.config_gem_handler_test_key_4,
                     handler.get(key)
        assert_equal ::Settings.config_gem_handler_test_key_4,
                     handler.get(key.upcase)

        # Doesn't look like we can remove it, so set it to nil
        ::Settings.config_gem_handler_test_key_4 = nil
      end

      test 'can get setting: case sensitive' do
        handler = ConfigGem.new

        ::Settings.config_gem_handler_test_key_5 = 'test'
        key = 'config_gem_handler_test_key_5'

        assert_equal ::Settings.config_gem_handler_test_key_5,
                     handler.get(key, case_sensitive: true)
        assert_nil handler.get(key.upcase, case_sensitive: true)

        # Doesn't look like we can remove it, so set it to nil
        ::Settings.config_gem_handler_test_key_5 = nil
      end

      test 'can get setting: key value is false' do
        handler = ConfigGem.new

        ::Settings.config_gem_handler_test_key_6 = false
        key = 'config_gem_handler_test_key_6'

        assert_equal ::Settings.config_gem_handler_test_key_6,
                     handler.get(key)
        assert_equal ::Settings.config_gem_handler_test_key_6,
                     handler.get(key.upcase, case_sensitive: false)

        # Doesn't look like we can remove it, so set it to nil
        ::Settings.config_gem_handler_test_key_6 = nil
      end
    end
  end
end
