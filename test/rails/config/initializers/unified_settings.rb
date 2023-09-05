# frozen_string_literal: true

# Configure the UnifiedSettings
UnifiedSettings.configure do |config|
  config.handlers = [
    UnifiedSettings::Handlers::Env,
    UnifiedSettings::Handlers::Credentials,
    {
      handler: UnifiedSettings::Handlers::ConfigGem,
      params: {
        const_name: 'Settings'
      }
    },
    UnifiedSettings::Handlers::Constants
  ]

  # Whether or not keys should be case sensitive. For example, let's assume the
  # key foo.bar.baz is defined in one of the locations the handlers are
  # configured to search. If we use case_sensitive = false then any of the
  # following examples will match
  #   UnifiedSettings.get('FOO.BAR.BAZ')
  #   UnifiedSettings.get('foo.bar.bar')
  #   UnifiedSettings.get('Foo.BaR.baZ')
  # If we set set case_sensitive = true, then only if the case exactly matches
  # the key is a result returned.
  # Default is: config.case_sensitive = false
  config.case_sensitive = false

  # This can be any of the following pre-defined handlers:
  #   :log_debug, :log_info, :log_warn, :log_error, :log_fatal, :raise
  # or you can pass an anonymous function that takes `key` as a parameter. E.g.
  #   config.on_missing_key = ->(key) { puts "Something is wrong with #{key}" }
  # If you need multiple things to happen, simply use an Array here. E.g.
  #   config.on_missing_key = [
  #     :log_fatal,
  #     ->(key) { puts "Something is wrong with #{key}" },
  #     :raise
  #   ]
  # This will run the handlers in the order that they were defined.
  #
  # Default is: config.on_missing_key = :log_error
  config.on_missing_key = :log_error

  # The value that should be returned if no key was found. This can be a set
  # to a particular value (e.g. `nil`, or `{}`), or can be an anonymous function
  # that takes `key` as a parameter. E.g.
  #   config.default_value = ->(key) { key.starts_with?('a') ? 'AA' : 'ZZ'}
  #
  # Default is: config.default_value = nil
  config.default_value = nil

  # The types that should be coerced from strings to their Ruby type.
  # (e.g. "true" to the boolean true or "1.2" to the float 1.2).
  # Default is: config.coercions = %i[nil boolean integer float]
  config.coercions = %i[nil boolean integer float]

  # Whether or not to coerce strings that look like arrays to arrays.
  # E.g. "a, B, true,1  " would be coerced become to ["a", "B", true, 1]
  # Defualt is:
  #   config.coerce_arrays = true
  #   config.coerce_array_separator = ','
  config.coerce_arrays = true
  config.coerce_array_separator = ','
end
