# frozen_string_literal: true

module UnifiedSettings
  module Handlers
    # Base handler for a setting source
    #
    # All handers should inherit from this base class and implement the method
    #   def get(key, case_sensitive: nil)
    class Base
      KEY_NESTING_SEPARATOR = '.'

      # rubocop:disable Lint/UnusedMethodArgument
      def get(key, case_sensitive: nil)
        raise 'Needs to be implemented by subclasss'
      end
      # rubocop:enable Lint/UnusedMethodArgument

      protected

      def split(val, separator)
        case val
        when String
          val.split(separator)
        when Symbol
          val.to_s.split(separator)
        when Array
          val
        else
          raise 'key must either be a string or an array'
        end
      end

      def case_sensitive?(case_sensitive)
        if case_sensitive.nil?
          UnifiedSettings.config.case_sensitive
        else
          case_sensitive
        end
      end

      def to_symbol_array(val, separator: KEY_NESTING_SEPARATOR)
        split(val, separator).map(&:to_sym)
      end

      def nested_key_exists?(hash, keys)
        return false if hash.nil?

        current_level = hash
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
