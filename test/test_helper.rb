# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)

require 'test/unit'

require 'minitest/autorun'
require 'active_record'
require 'unified_settings'

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3', database: ':memory:'
)
