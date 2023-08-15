# frozen_string_literal: true

require_relative 'base'

module UnifiedSettings
  module Handlers
    # Setting handler for Config gem
    class ConfigGem < Base
      # By default the gem makes a `Settings` object available
      DEFAULT_CONST_NAME = 'Settings'

      def initialize(const_name: nil)
        super()
        @const_name = const_name || DEFAULT_CONST_NAME
      end

      def defined?(key, case_sensitive: nil)
        key_arr = to_symbol_array(key)
        case_sensitive = case_sensitive?(case_sensitive)

        return true if nested_key_exists?(setting_obj, key_arr)
        return false if case_sensitive

        return true if nested_key_exists?(setting_obj, key_arr.map(&:upcase))
        return true if nested_key_exists?(setting_obj, key_arr.map(&:downcase))

        false
      end

      def get(key, case_sensitive: nil)
        key_arr = to_symbol_array(key)
        case_sensitive = case_sensitive?(case_sensitive)

        val = setting_obj.dig(*key_arr)
        return val unless val.nil?
        return nil if case_sensitive

        val = setting_obj.dig(*key_arr.map(&:downcase))
        return val unless val.nil?

        setting_obj.dig(*key_arr.map(&:upcase))
      end

      private

      def setting_obj
        Object.const_get("::#{@const_name}")
      end
    end
  end
end
