# frozen_string_literal: true

require_relative 'base'

module UnifiedSettings
  module Handlers
    # Settings handler for ENV variables
    class Env < Base
      ENV_KEY_NESTING_SEPARATOR = '__'

      def defined?(key, case_sensitive: nil)
        key_arr = to_symbol_array(key)
        case_sensitive = case_sensitive?(case_sensitive)

        return true if ENV.key?(key_arr.join(ENV_KEY_NESTING_SEPARATOR))
        return false if case_sensitive

        return true if ENV.key?(
          key_arr.map(&:upcase).join(ENV_KEY_NESTING_SEPARATOR)
        )
        return true if ENV.key?(
          key_arr.map(&:downcase).join(ENV_KEY_NESTING_SEPARATOR)
        )

        false
      end

      def get(key, case_sensitive: nil)
        key_arr = to_symbol_array(key)
        case_sensitive = case_sensitive?(case_sensitive)

        val = ENV.fetch(key_arr.join(ENV_KEY_NESTING_SEPARATOR), nil)
        return val if val
        return nil if case_sensitive

        val = ENV.fetch(
          key_arr.map(&:upcase).join(ENV_KEY_NESTING_SEPARATOR), nil
        )
        return val if val

        ENV.fetch(
          key_arr.map(&:downcase).join(ENV_KEY_NESTING_SEPARATOR), nil
        )
      end
    end
  end
end
