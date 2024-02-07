# frozen_string_literal: true

require 'test_helper'

module UnifiedSettings
  class SettingsTest < ActiveSupport::TestCase
    TEST_CONSTANT = 'test'

    setup do
      # All of these tests will work according to how the library was
      # configured as per test/rails/config/initializers/unified_settings.rb
      @settings = Settings.new
    end

    test 'can provide a default value for missing keys' do
      key = SecureRandom.uuid.to_s

      assert_nil @settings.get(key)
      assert_equal 'DEFAULT', @settings.get(key, default: 'DEFAULT')
      refute @settings.get(key, default: false)
      assert_nil @settings.get(key, default: nil)
      assert_equal 1, @settings.get(key, default: 1)
      assert_equal [1, 2], @settings.get(key, default: [1, 2])
    end

    test 'can check if setting defined from environment variable' do
      key = ENV.keys.first

      assert @settings.defined?(key)
      assert @settings.defined?(key.upcase)
      assert @settings.defined?(key.downcase)

      # Since we are using a random constant, we don't know what it's really
      # supposed to be. Since the last constant may be different in different
      # environments, make this test work in all situations.
      assert @settings.defined?(key, case_sensitive: true)
      if uppercase?(key)
        refute @settings.defined?(key.downcase, case_sensitive: true)
      elsif lowercase?(key)
        refute @settings.defined?(key.upcase, case_sensitive: true)
      else
        refute @settings.defined?(key.downcase,
                                  case_sensitive: true)
        refute @settings.defined?(key.upcase, case_sensitive: true)
      end
    end

    test 'can check if setting defined from Rails credentials' do
      key = 'test_credential_1'

      assert @settings.defined?(key)
      assert @settings.defined?(key.to_sym)
      assert @settings.defined?(key.upcase)
      assert @settings.defined?(key.downcase)

      assert @settings.defined?(key, case_sensitive: true)
      refute @settings.defined?(key.upcase, case_sensitive: true)
    end

    test 'can check if setting defined from Config gem Setting object' do
      # Ensure we are using the gem Settings object
      assert_not_equal ::Settings.class, @settings.class

      ::Settings.test_key_2 = 'test'

      assert @settings.defined?('test_key_2')
      assert @settings.defined?('test_key_2'.upcase)
      assert @settings.defined?('test_key_2'.downcase)

      assert @settings.defined?('test_key_2', case_sensitive: true)
      refute @settings.defined?('test_key_2'.upcase, case_sensitive: true)

      # Doesn't look like we can remove it, so set it to nil
      ::Settings.test_key = nil
    end

    test 'can check if setting defined from a global constant' do
      key = Object.constants.last

      assert @settings.defined?(key)
      assert @settings.defined?(key.upcase)
      assert @settings.defined?(key.downcase)

      # Since we are using a random constant, we don't know what it's really
      # supposed to be. Since the last constant may be different in different
      # environments, make this test work in all situations.
      assert @settings.defined?(key, case_sensitive: true)
      if uppercase?(key)
        refute @settings.defined?(key.downcase, case_sensitive: true)
      elsif lowercase?(key)
        refute @settings.defined?(key.upcase, case_sensitive: true)
      else
        refute @settings.defined?(key.downcase,
                                  case_sensitive: true)
        refute @settings.defined?(key.upcase, case_sensitive: true)
      end
    end

    test 'can check if setting defined from constant defined in a class' do
      assert \
        @settings.defined?('UnifiedSettings::SettingsTest::TEST_CONSTANT')
      assert \
        @settings.defined?(
          'UnifiedSettings::SettingsTest::Test_Constant'
        )
      assert \
        @settings.defined?(
          'UnifiedSettings::SettingsTest::test_constant'
        )

      assert \
        @settings.defined?(
          'UnifiedSettings::SettingsTest::TEST_CONSTANT',
          case_sensitive: true
        )
      refute \
        @settings.defined?(
          'UnifiedSettings::SettingsTest::Test_Constant',
          case_sensitive: true
        )
      refute \
        @settings.defined?(
          'UnifiedSettings::SettingsTest::test_constant',
          case_sensitive: true
        )
    end

    test 'can get setting from environment variable' do
      key = ENV.keys.first

      # Make sure to turn off coercion as the ENV variable might be a
      # boolean, integer, etc that gets auto-coerced by default
      assert_equal ENV.fetch(key, nil), @settings.get(key, coerce: false)
      assert_equal ENV.fetch(key, nil), @settings.get(key.upcase, coerce: false)
      assert_equal ENV.fetch(key, nil),
                   @settings.get(key.downcase, coerce: false)

      # Since we are using a random constant, we don't know what it's really
      # supposed to be. Since the last constant may be different in different
      # environments, make this test work in all situations.
      assert_equal ENV.fetch(key, nil),
                   @settings.get(key, case_sensitive: true, coerce: false)
      if uppercase?(key)
        assert_nil @settings.get(key.downcase, case_sensitive: true)
      elsif lowercase?(key)
        assert_nil @settings.get(key.upcase, case_sensitive: true)
      else
        assert_nil @settings.get(key.downcase, case_sensitive: true)
        assert_nil @settings.get(key.upcase, case_sensitive: true)
      end
    end

    test 'can get setting from Rails credentials' do
      Rails.application.credentials.test_key_1 = 'test'

      assert_equal Rails.application.credentials.test_key_1,
                   @settings.get('test_key_1')
      assert_equal Rails.application.credentials.test_key_1,
                   @settings.get('test_key_1'.upcase)
      assert_equal Rails.application.credentials.test_key_1,
                   @settings.get('test_key_1'.downcase)

      assert_equal Rails.application.credentials.test_key_1,
                   @settings.get('test_key_1', case_sensitive: true)
      assert_nil @settings.get('test_key_1'.upcase, case_sensitive: true)

      Rails.application.credentials.pop('test_key_1')
    end

    test 'can get setting from Config gem Setting object' do
      # Ensure we are using the gem Settings object
      assert_not_equal ::Settings.class, @settings.class

      ::Settings.test_key_2 = 'test'

      assert_equal ::Settings.test_key_2, @settings.get('test_key_2')
      assert_equal ::Settings.test_key_2, @settings.get('test_key_2'.upcase)
      assert_equal ::Settings.test_key_2, @settings.get('test_key_2'.downcase)

      assert_equal ::Settings.test_key_2, @settings.get('test_key_2')
      assert_nil @settings.get('test_key_2'.upcase, case_sensitive: true)

      # Doesn't look like we can remove it, so set it to nil
      ::Settings.test_key = nil
    end

    test 'can get setting from a global constant' do
      key = Object.constants.last

      assert_equal Object.const_get(key), @settings.get(key)
      assert_equal Object.const_get(key), @settings.get(key.upcase)
      assert_equal Object.const_get(key), @settings.get(key.downcase)

      # Since we are using a random constant, we don't know what it's really
      # supposed to be. Since the last constant may be different in different
      # environments, make this test work in all situations.
      assert_equal Object.const_get(key),
                   @settings.get(key, case_sensitive: true)
      if uppercase?(key)
        assert_nil @settings.get(key.downcase, case_sensitive: true)
      elsif lowercase?(key)
        assert_nil @settings.get(key.upcase, case_sensitive: true)
      else
        assert_nil @settings.get(key.downcase, case_sensitive: true)
        assert_nil @settings.get(key.upcase, case_sensitive: true)
      end
    end

    test 'can get setting from constant defined in a class' do
      assert_equal \
        SettingsTest::TEST_CONSTANT,
        @settings.get('UnifiedSettings::SettingsTest::TEST_CONSTANT')
      assert_equal \
        SettingsTest::TEST_CONSTANT,
        @settings.get('UnifiedSettings::SettingsTest::Test_Constant')
      assert_equal \
        SettingsTest::TEST_CONSTANT,
        @settings.get('UnifiedSettings::SettingsTest::test_constant')

      assert_equal \
        SettingsTest::TEST_CONSTANT,
        @settings.get('UnifiedSettings::SettingsTest::TEST_CONSTANT')
      assert_nil @settings.get(
        'UnifiedSettings::SettingsTest::Test_Constant',
        case_sensitive: true
      )
      assert_nil @settings.get(
        'UnifiedSettings::SettingsTest::test_constant',
        case_sensitive: true
      )
    end

    test 'does get first matching setting' do
      Rails.application.credentials.test_key_3 = 'From Credentials'
      ::Settings.test_key_3 = 'From Config::Settings'

      assert_equal 'From Credentials', @settings.get('test_key_3')

      Rails.application.credentials.pop('test_key_3')
      ::Settings.test_key_3 = nil
    end

    test 'can provide custom handlers' do
      settings = Settings.new(handlers: [UnifiedSettings::Handlers::ConfigGem])

      Rails.application.credentials.test_key_4 = 'From Credentials'
      ::Settings.test_key_4 = 'From Config::Settings'

      # Since it only has the settings handler, it will not look in the
      # Rails credentials
      assert_equal 'From Config::Settings', settings.get('test_key_4')

      Rails.application.credentials.pop('test_key_4')
      ::Settings.test_key_4 = nil
    end

    test 'does properly coerce values in Credentials' do
      [
        ['true', true],
        ['false', false],
        ['1', 1],
        ['2.2', 2.2],
        ['nil', nil],
        ['a,B,c,D,e1,F2', %w[a B c D e1 F2]],
        ['a,B,true,nil,1,2.2', ['a', 'B', true, nil, 1, 2.2]],
        ['a  , B, true ,nil ,1,  2.2', ['a', 'B', true, nil, 1, 2.2]]
      ].each do |test_case|
        string_value = test_case[0]
        expected_value = test_case[1]

        Rails.application.credentials.test_cred_coercion_key = string_value

        if expected_value.nil?
          assert_nil @settings.get('test_cred_coercion_key')
          assert_nil @settings.get('test_cred_coercion_key', coerce: true)
        else
          assert_equal expected_value, @settings.get('test_cred_coercion_key')
          assert_equal expected_value,
                       @settings.get('test_cred_coercion_key', coerce: true)
        end

        assert_equal string_value,
                     @settings.get('test_cred_coercion_key', coerce: false)

        Rails.application.credentials.pop('test_cred_coercion_key')
      end
    end

    test 'does properly coerce values in Config gem' do
      # Ensure we are using the gem Settings object
      assert_not_equal ::Settings.class, @settings.class

      [
        ['true', true],
        ['false', false],
        ['1', 1],
        ['2.2', 2.2],
        ['nil', nil],
        ['a,B,c,D,e1,F2', %w[a B c D e1 F2]],
        ['a,B,true,nil,1,2.2', ['a', 'B', true, nil, 1, 2.2]],
        ['a  , B, true ,nil ,1,  2.2', ['a', 'B', true, nil, 1, 2.2]]
      ].each do |test_case|
        string_value = test_case[0]
        expected_value = test_case[1]

        ::Settings.test_config_coercion_key = string_value

        if expected_value.nil?
          assert_nil @settings.get('test_config_coercion_key')
          assert_nil @settings.get('test_config_coercion_key', coerce: true)
        else
          assert_equal expected_value,
                       @settings.get('test_config_coercion_key')
          assert_equal expected_value,
                       @settings.get('test_config_coercion_key', coerce: true)
        end

        assert_equal string_value,
                     @settings.get('test_config_coercion_key', coerce: false)

        # Doesn't look like we can remove it, so set it to nil
        ::Settings.test_key = nil
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
