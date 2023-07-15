# frozen_string_literal: true

require 'logger'

# Unified way to get settings
module UnifiedSettings
  include ActiveSupport::Configurable

  NO_DEFAULT = :no_default

  def self.configure
    # Set the defaults
    config.handlers = [
      Handlers::Env, Handlers::Credentials, Handlers::Constants
    ]
    config.default_value = nil
    config.case_sensitive = false
    config.on_missing_key = [:log_error]
    config.coercions = %i[nil boolean integer float]
    config.coerce_arrays = true
    config.coerce_array_separator = ','

    super

    # Create an instance of the settings that can be used
    @settings = Settings.new
  end

  def self.defined?(key, case_sensitive: nil, handlers: nil)
    settings = handlers.nil? ? @settings : Settings.new(handlers:)
    settings.defined?(key, case_sensitive:)
  end

  # rubocop:disable Metrics/ParameterLists
  def self.get(
    key, default: NO_DEFAULT, case_sensitive: nil, handlers: nil, coerce: true,
    on_missing_key: nil
  )
    settings = handlers.nil? ? @settings : Settings.new(handlers:)
    settings.get(
      key,
      case_sensitive:,
      coerce:,
      on_missing_key:,
      default:
    )
  end
  # rubocop:enable Metrics/ParameterLists
end
