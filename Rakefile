# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rake/testtask'

Rake::TestTask.new(:test) do |t|
  t.verbose = true
  t.libs << 'test'
  t.libs << 'lib'
  t.libs << 'test/dummy'

  # We will include all of the files in test but are going to explicitly
  # exclude all tests in rails. This is because we copy those files
  # to the dummy Rails app so that we can test the Rails specific handlers
  # in the context of a Rails app. See the `generate_dummy_rails_app` for
  # more details
  t.test_files = \
    FileList['test/**/*_test.rb'].exclude('test/rails/**/*_test.rb')
end

desc 'generate a dummy Rails app inside the test directory for testing purposes'
task :generate_dummy_rails_app do
  if File.exist?('test/dummy/config/environment.rb')
    FileUtils.rm_r Dir.glob('test/dummy/')
  end

  #
  # Create a dummy rails app
  #
  system(
    'rails new test/dummy --skip-active-record ' \
    '--skip-active-storage --skip-action-cable --skip-webpack-install ' \
    '--skip-git --skip-sprockets --skip-javascript --skip-turbolinks'
  )

  # For now we don't need any DB specific things in our tests. However, if
  # we ever do, we can update how we generate the rails app and then setup
  # the DB appropriately using something like the following.
  # system('rails new test/dummy --database=sqlite3')
  # system('touch test/dummy/db/schema.rb')
  # FileUtils.cp 'test/fixtures/database.yml', 'test/dummy/config/'

  #
  # Install/Setup the dependencies
  #

  system('cp -f test/rails/Gemfile test/dummy/.')

  # Setup the Config gem
  system('cd test/dummy; rails g config:install')
  system(
    'cp test/rails/config/initializers/config.rb ' \
    'test/dummy/config/initializers/.'
  )

  #
  # Setup the tests by deleting the existing Rails app tests and then copying
  # our test over to the dummy app
  #

  FileUtils.rm_r Dir.glob('test/dummy/test/*')
  system('cp -r test/rails/test/lib test/dummy/test/.')
end

require 'rubocop/rake_task'
RuboCop::RakeTask.new

task default: %i[generate_dummy_rails_app test rubocop]
