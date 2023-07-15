# frozen_string_literal: true

require 'test_helper'

class CoercerTest < Minitest::Test
  def test_can_coerce_nil_strings_to_nil
    coercer = UnifiedSettings::Coercer.new(coercions: [:nil])

    assert_nil coercer.coerce('nil')
    assert_nil coercer.coerce('Nil')
    assert_nil coercer.coerce('  nil  ')
  end

  def test_can_coerce_boolean_strings_to_boolean
    coercer = UnifiedSettings::Coercer.new(coercions: [:boolean])

    assert coercer.coerce('true')
    assert coercer.coerce('TRUE')
    assert coercer.coerce('TrUe')
    assert coercer.coerce('  true  ')
    refute coercer.coerce('false')
    refute coercer.coerce('FALSE')
    refute coercer.coerce('FaLsE')
    refute coercer.coerce('  false  ')
  end

  def test_can_coerce_integer_strings_to_integer
    coercer = UnifiedSettings::Coercer.new(coercions: [:integer])

    assert_equal 1, coercer.coerce('1')
    assert_equal 100, coercer.coerce('100')
    assert_equal(-1000, coercer.coerce('-1000'))
    assert_equal(-10_000, coercer.coerce('  -10000  '))
  end

  def test_can_coerce_float_strings_to_float
    coercer = UnifiedSettings::Coercer.new(coercions: [:float])

    assert_in_delta(1.0, coercer.coerce('1.0'))
    assert_in_delta(100.9, coercer.coerce('100.9'))
    assert_in_delta(-1000.987, coercer.coerce('-1000.987'))
    assert_in_delta(-10_000.12, coercer.coerce('  -10000.12  '))
  end

  def test_can_coerce_array_of_strings_to_array
    coercer = UnifiedSettings::Coercer.new(coerce_arrays: true)

    assert_equal 'string', coercer.coerce('string')
    assert_equal %w[string1 string2], coercer.coerce('string1,string2')
    assert_equal %w[string1 string2], coercer.coerce(' string1,  string2 ')
  end

  def test_can_coerce_array_of_strings_to_array_with_custom_separator
    coercer = UnifiedSettings::Coercer.new(coerce_arrays: true,
                                           array_separator: '|')

    assert_equal 'string', coercer.coerce('string')
    assert_equal 'string1,string2', coercer.coerce('string1,string2')
    assert_equal 'string1,  string2', coercer.coerce('  string1,  string2  ')
    assert_equal %w[string1 string2], coercer.coerce('string1|string2')
    assert_equal %w[string1 string2], coercer.coerce(' string1|  string2 ')
  end

  def test_can_coerce_array_of_various_types_to_array
    coercer = UnifiedSettings::Coercer.new(
      coercions: %i[nil boolean integer float], coerce_arrays: true
    )

    assert_equal ['string', true, false, 1, 2.2],
                 coercer.coerce('string,true,false,1,2.2')
    assert_equal ['string', true, false, 1, 2.2],
                 coercer.coerce('  string, tRue,   false,1,      2.2 ')
  end

  def test_does_coerce_arrays_and_all_types_by_default
    coercer = UnifiedSettings::Coercer.new

    assert_equal ['string', true, false, 1, 2.2, nil],
                 coercer.coerce('string,true,false,1,2.2,nil')
    assert_equal ['string', true, false, 1, 2.2, nil],
                 coercer.coerce('  string, tRue,   false,1,      2.2, NiL ')
  end

  def test_can_disable_coercion
    coercer = UnifiedSettings::Coercer.new(coercions: [],
                                           coerce_arrays: false)

    assert_equal 'string,true,false,1,2.2,nil',
                 coercer.coerce('string,true,false,1,2.2,nil')
    assert_equal 'string, tRue,   false,1,      2.2, NiL',
                 coercer.coerce('  string, tRue,   false,1,      2.2, NiL ')
  end
end
