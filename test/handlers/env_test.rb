# frozen_string_literal: true

require 'test_helper'

module UnifiedSettings
  module Handlers
    class EnvTest < Minitest::Test
      def test_can_check_if_setting_is_defined_case_insesitive
        handler = ::UnifiedSettings::Handlers::Env.new
        key = ENV.keys.first

        assert handler.defined?(key)
        assert handler.defined?(key.upcase)
        assert handler.defined?(key.downcase)
      end

      def test_can_check_if_setting_is_defined_case_sesitive
        handler = ::UnifiedSettings::Handlers::Env.new
        key = ENV.keys.first

        # Since we are using a random constant, we don't know what it's really
        # supposed to be. Since the last constant may be different in different
        # environments, make this test work in all situations.
        assert handler.defined?(key, case_sensitive: true)
        if uppercase?(key)
          refute handler.defined?(key.downcase, case_sensitive: true)
        elsif lowercase?(key)
          refute handler.defined?(key.upcase, case_sensitive: true)
        else
          refute handler.defined?(key.downcase, case_sensitive: true)
          refute handler.defined?(key.upcase, case_sensitive: true)
        end
      end

      def test_can_get_setting_case_insensitive
        handler = ::UnifiedSettings::Handlers::Env.new
        key = ENV.keys.first

        assert_equal ENV.fetch(key, nil), handler.get(key)
        assert_equal ENV.fetch(key, nil), handler.get(key.upcase)
        assert_equal ENV.fetch(key, nil), handler.get(key.downcase)
      end

      def test_can_get_setting_case_sensitive
        handler = ::UnifiedSettings::Handlers::Env.new
        key = ENV.keys.first

        # Since we are using a random constant, we don't know what it's really
        # supposed to be. Since the last constant may be different in different
        # environments, make this test work in all situations.
        assert_equal ENV.fetch(key, nil),
                     handler.get(key, case_sensitive: true)
        if uppercase?(key)
          assert_nil handler.get(key.downcase, case_sensitive: true)
        elsif lowercase?(key)
          assert_nil handler.get(key.upcase, case_sensitive: true)
        else
          assert_nil handler.get(key.downcase, case_sensitive: true)
          assert_nil handler.get(key.upcase, case_sensitive: true)
        end
      end

      private

      def uppercase?(str)
        str == str.upcase
      end

      def lowercase?(str)
        str == str.downcase
      end
    end
  end
end
