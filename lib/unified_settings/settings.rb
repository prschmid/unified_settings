# frozen_string_literal: true

module UnifiedSettings
  # Settings
  #
  # Main interface for getting any of the settings
  class Settings
    attr_accessor :handlers

    def initialize(handlers: nil)
      handlers_config = handlers || UnifiedSettings.config.handlers
      @handlers = handlers_config.map { |config| initialize_handler(config) }
      @coercer = Coercer.new(
        coercions: UnifiedSettings.config.coercions,
        coerce_arrays: UnifiedSettings.config.coerce_arrays,
        array_separator: UnifiedSettings.config.coerce_array_separator
      )
    end

    def defined?(key, case_sensitive: nil)
      return false unless key

      @handlers.each do |handler|
        return true if handler.defined?(key, case_sensitive:)
      end

      false
    end

    def get(
      key, default: NO_DEFAULT, case_sensitive: nil, coerce: true,
      on_missing_key: nil
    )
      return nil unless key

      @handlers.each do |handler|
        val = handler.get(key, case_sensitive:)
        unless val.nil?
          return coerce ? @coercer.coerce(val) : val
        end
      end

      handle_missing_key(key, default:, on_missing_key:)
    end

    private

    def initialize_handler(config)
      handler, params = if config.respond_to?(:keys)
                          [config[:handler], config[:params]]
                        else
                          [config, nil]
                        end

      case handler
      when String
        klass = handler.safe_constantize
        params.blank? ? klass.new : klass.new(**params)
      when Class
        params.blank? ? handler.new : handler.new(**params)
      when SettingHandler
        handler
      else
        raise 'UnifiedSettings: Unsupported handler. Handlers must be an ' \
              'array of strings, classes, or instances of ' \
              'UnifiedSettings::SettingHandler'
      end
    end

    def handle_missing_key(key, default: NO_DEFAULT, on_missing_key: nil)
      handle_on_missing_key(key, on_missing_key:)

      val = if default == NO_DEFAULT
              UnifiedSettings.config.default_value
            else
              default
            end
      return val.call(key) if val.respond_to?(:call)

      val
    end

    # rubocop:disable Metrics/CyclomaticComplexity
    def handle_on_missing_key(key, on_missing_key: nil)
      actions = on_missing_key || UnifiedSettings.config.on_missing_key
      actions = [actions] unless actions.is_a?(Array)

      actions.each do |action|
        if action.respond_to?(:call)
          action.call(key)
          next
        end

        case action
        when :raise
          on_missing_key_raise(key)
        when :log_debug
          on_missing_key_log(Logger::DEBUG, key)
        when :log_info
          on_missing_key_log(Logger::INFO, key)
        when :log_warn
          on_missing_key_log(Logger::WARN, key)
        when :log_error
          on_missing_key_log(Logger::ERROR, key)
        when :log_fatal
          on_missing_key_log(Logger::FATAL, key)
        else
          raise "UnifiedSettings: Unknown on_missing_key handler: '#{action}'"
        end
      end
    end
    # rubocop:enable Metrics/CyclomaticComplexity

    def on_missing_key_raise(key)
      raise error_message(key)
    end

    def on_missing_key_log(level, key)
      ::Rails.logger.add(level) { error_message(key) }
    rescue NoMethodError
      logger = Logger.new($stdout, Logger::INFO)
      logger.add(level) { error_message(key) }
    end

    def error_message(key)
      "UnifiedSettings: No matches found for '#{key}'"
    end
  end
end
