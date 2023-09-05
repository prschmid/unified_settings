# frozen_string_literal: true

# Configure Rails Environment for the dummy testing Rails app
ENV['RAILS_ENV'] = 'test'

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)

require 'minitest/autorun'
require 'active_record'
require 'unified_settings'

# Include the dummy Rails app so we can run the tests for the components
# that require Rails
require File.expand_path('dummy/config/environment.rb', __dir__)

# We don't need to include this for now, but keeping this for now incase we
# need it in the future.
# require 'test/unit' # or possibly rspec/minispec
