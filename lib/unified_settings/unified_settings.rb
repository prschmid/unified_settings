# frozen_string_literal: true

require 'logger'

# Unified way to get settings
module UnifiedSettings
  # Config object to emulate ActiveSupport::Configurable behavior that is
  # deprecated in Rails 8.2
  class Config
    attr_accessor :handlers, :default_value, :case_sensitive, :on_missing_key,
                  :coercions, :coerce_arrays, :coerce_array_separator

    def initialize
      @handlers = [
        Handlers::Env, Handlers::Credentials, Handlers::Constants
      ]
      @default_value = nil
      @case_sensitive = false
      @on_missing_key = [:log_error]
      @coercions = %i[nil boolean integer float]
      @coerce_arrays = true
      @coerce_array_separator = ','
    end
  end

  NO_DEFAULT = :no_default

  def self.config
    @config ||= Config.new
  end

  def self.configure
    yield config if block_given?

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
