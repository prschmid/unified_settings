# frozen_string_literal: true

require 'unified_settings/version'

directories = [
  File.join(File.dirname(__FILE__), 'unified_settings'),
  File.join(File.dirname(__FILE__), 'unified_settings', 'handlers')
]

directories.each do |directory|
  Dir[File.join(directory, '*.rb')].each do |file|
    require file
  end
end

begin
  require 'active_record'
  ActiveRecord::Base.instance_eval { include UnifiedSettings }
rescue LoadError => e
  # rubocop:disable Rails/Output
  puts "ERROR: Could not load active_record: #{e.message}"
  # rubocop:enable Rails/Output
end

if defined?(Rails) && Rails.version.to_i < 4
  raise 'This version of unified_settings requires Rails 4 or higher'
end
