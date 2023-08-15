# frozen_string_literal: true

require 'test_helper'

module UnifiedSettings
  module Handlers
    class ConstantsTest < Minitest::Test
      TEST_CONST = 'test'
      TEST_CONST_FALSE_VALUE = false

      def test_can_check_if_global_constant_is_defined_case_insesitive
        handler = ::UnifiedSettings::Handlers::Constants.new
        key = Object.constants.last

        assert handler.defined?(key)
        assert handler.defined?(key.upcase)
        assert handler.defined?(key.downcase)
      end

      def test_can_check_if_class_constant_is_defined_case_insesitive
        handler = ::UnifiedSettings::Handlers::Constants.new

        assert handler.defined?(
          'UnifiedSettings::Handlers::ConstantsTest::TEST_CONST'
        )
        assert handler.defined?(
          'UnifiedSettings::Handlers::ConstantsTest::Test_Const'
        )
        assert handler.defined?(
          'UnifiedSettings::Handlers::ConstantsTest::test_const'
        )
      end

      def test_can_check_if_global_constant_is_defined_case_sesitive
        handler = ::UnifiedSettings::Handlers::Constants.new
        key = Object.constants.last

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

      def test_can_check_if_class_constant_is_defined_case_sesitive
        handler = ::UnifiedSettings::Handlers::Constants.new

        assert handler.defined?(
          'UnifiedSettings::Handlers::ConstantsTest::TEST_CONST',
          case_sensitive: true
        )
        refute handler.defined?(
          'UnifiedSettings::Handlers::ConstantsTest::Test_Const',
          case_sensitive: true
        )
        refute handler.defined?(
          'UnifiedSettings::Handlers::ConstantsTest::test_const',
          case_sensitive: true
        )
      end

      def test_can_check_if_class_constant_is_defined_key_value_is_false
        handler = ::UnifiedSettings::Handlers::Constants.new

        assert handler.defined?(
          'UnifiedSettings::Handlers::ConstantsTest::TEST_CONST_FALSE_VALUE',
          case_sensitive: true
        )
        refute handler.defined?(
          'UnifiedSettings::Handlers::ConstantsTest::Test_Const_False_Value',
          case_sensitive: true
        )
        refute handler.defined?(
          'UnifiedSettings::Handlers::ConstantsTest::test_const_false_value',
          case_sensitive: true
        )
      end

      def test_can_get_global_constant_case_insensitive
        handler = ::UnifiedSettings::Handlers::Constants.new
        key = Object.constants.last

        assert_equal Object.const_get(key), handler.get(key)
        assert_equal Object.const_get(key), handler.get(key.upcase)
        assert_equal Object.const_get(key), handler.get(key.downcase)
      end

      def test_can_get_class_constant_case_insensitive
        handler = ::UnifiedSettings::Handlers::Constants.new

        assert_equal ConstantsTest::TEST_CONST,
                     handler.get(
                       'UnifiedSettings::Handlers::ConstantsTest::TEST_CONST'
                     )
        assert_equal ConstantsTest::TEST_CONST,
                     handler.get(
                       'UnifiedSettings::Handlers::ConstantsTest::Test_Const'
                     )
        assert_equal ConstantsTest::TEST_CONST,
                     handler.get(
                       'UnifiedSettings::Handlers::ConstantsTest::test_const'
                     )
      end

      def test_can_get_global_constant_case_sensitive
        handler = ::UnifiedSettings::Handlers::Constants.new
        key = Object.constants.last

        # Since we are using a random constant, we don't know what it's really
        # supposed to be. Since the last constant may be different in different
        # environments, make this test work in all situations.
        assert_equal Object.const_get(key),
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

      def test_can_get_class_constant_case_sensitive
        handler = ::UnifiedSettings::Handlers::Constants.new

        assert_equal \
          ConstantsTest::TEST_CONST,
          handler.get(
            'UnifiedSettings::Handlers::ConstantsTest::TEST_CONST',
            case_sensitive: true
          )
        assert_nil handler.get(
          'UnifiedSettings::Handlers::ConstantsTest::Test_Const',
          case_sensitive: true
        )
        assert_nil handler.get(
          'UnifiedSettings::Handlers::ConstantsTest::test_const',
          case_sensitive: true
        )
      end

      def test_can_get_class_constant_key_value_is_false
        handler = ::UnifiedSettings::Handlers::Constants.new

        assert_equal \
          ConstantsTest::TEST_CONST_FALSE_VALUE,
          handler.get(
            'UnifiedSettings::Handlers::ConstantsTest::TEST_CONST_FALSE_VALUE'
          )
        assert_equal \
          ConstantsTest::TEST_CONST_FALSE_VALUE,
          handler.get(
            'UnifiedSettings::Handlers::ConstantsTest::test_const_false_value',
            case_sensitive: false
          )
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
