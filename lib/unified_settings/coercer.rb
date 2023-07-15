# frozen_string_literal: true

module UnifiedSettings
  #
  # This will take string values and coerce them to the approrpiate ruby
  # objects (e.g. "true" to the boolean true or "1.2" to the float 1.2)
  #
  class Coercer
    def initialize(
      coercions: %i[nil boolean integer float],
      coerce_arrays: true,
      array_separator: ','
    )
      @coercions = coercions
      @coerce_arrays = coerce_arrays
      @array_separator = array_separator
    end

    def coerce(value)
      return value unless value

      # If it's already been cast to something other than a string, just
      # return what it is.
      return value unless value.is_a?(String)

      stripped_value = value.strip

      coerced_value, is_array = coerce_to_array(stripped_value)
      if is_array
        coerced_value.map do |array_value|
          array_value = array_value.strip
          coerced_value, did_coerce = coerce_value(array_value)
          did_coerce ? coerced_value : array_value
        end
      else
        coerced_value, did_coerce = coerce_value(stripped_value)
        did_coerce ? coerced_value : stripped_value
      end
    end

    private

    def coerce_value(value)
      return [value, false] unless value

      coerced_value, did_coerce = coerce_to_nil(value)
      return [coerced_value, did_coerce] if did_coerce

      coerced_value, did_coerce = coerce_to_boolean(value)
      return [coerced_value, did_coerce] if did_coerce

      coerced_value, did_coerce = coerce_to_integer(value)
      return [coerced_value, did_coerce] if did_coerce

      coerced_value, did_coerce = coerce_to_float(value)
      return [coerced_value, did_coerce] if did_coerce

      [value, false]
    end

    def coerce_to_array(value)
      return [value, false] unless @coerce_arrays
      return [value, false] unless value.include?(@array_separator)

      [value.split(@array_separator), true]
    end

    def coerce_to_nil(value)
      return [value, false] unless @coercions.include?(:nil)
      return [nil, true] if value.casecmp('nil').zero?

      [value, false]
    end

    def coerce_to_boolean(value)
      return [value, false] unless @coercions.include?(:boolean)
      return [true, true] if value.casecmp('true').zero?
      return [false, true] if value.casecmp('false').zero?

      [value, false]
    end

    def coerce_to_integer(value)
      return [value, false] unless @coercions.include?(:integer)

      begin
        return [Integer(value), true]
      rescue ArgumentError # rubocop:disable Lint/SuppressedException
      end

      [value, false]
    end

    def coerce_to_float(value)
      return [value, false] unless @coercions.include?(:float)

      begin
        return [Float(value), true]
      rescue ArgumentError # rubocop:disable Lint/SuppressedException
      end

      [value, false]
    end
  end
end
