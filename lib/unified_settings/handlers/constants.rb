# frozen_string_literal: true

require_relative 'base'

module UnifiedSettings
  module Handlers
    # Setting handler for Ruby constants
    class Constants < Base
      CONSTANT_KEY_NESTING_SEPARATOR = '::'

      def defined?(key, case_sensitive: nil)
        klass, variable_names = key_to_class_and_variable(
          key, case_sensitive:
        )

        variable_names.each do |name|
          if klass
            return true if klass.const_get(name)
          elsif Object.const_get(name)
            return true
          end
        rescue NameError
          # Ignore if the constant is not defined
        end

        false
      end

      def get(key, case_sensitive: nil)
        klass, variable_names = key_to_class_and_variable(
          key, case_sensitive:
        )

        variable_names.each do |name|
          return klass.const_get(name) if klass

          return Object.const_get(name)
        rescue NameError
          # Ignore if the constant is not defined
        end

        nil
      end

      private

      def key_to_class_and_variable(key, case_sensitive: nil)
        key_arr = to_symbol_array(key,
                                  separator: CONSTANT_KEY_NESTING_SEPARATOR)
        case_sensitive = case_sensitive?(case_sensitive)

        klass, variable =
          if key_arr.length > 1
            [
              key_arr[0..-2].join(CONSTANT_KEY_NESTING_SEPARATOR)
                            .safe_constantize,
              key_arr[-1]
            ]
          else
            [nil, key_arr[0]]
          end

        variable_names = if case_sensitive
                           [variable]
                         else
                           [variable, variable.upcase, variable.downcase]

                         end

        [klass, variable_names]
      end
    end
  end
end
