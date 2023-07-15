# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'unified_settings/version'

Gem::Specification.new do |spec|
  spec.name = 'unified_settings'
  spec.version = UnifiedSettings::VERSION
  spec.authors       = ['Patrick R. Schmid']
  spec.email         = ['prschmid@gmail.com']

  spec.summary       = 'A unified way to get settings from different sources.'
  spec.description   = 'A unified way to get settings from different sources.'
  spec.homepage      = 'https://github.com/prschmid/unified_settings'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the
  # 'allowed_push_host' to allow pushing to a single host or delete this
  # section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['homepage_uri'] = spec.homepage
    spec.metadata['source_code_uri'] = 'https://github.com/prschmid/unified_settings'
    spec.metadata['changelog_uri'] = 'https://github.com/prschmid/unified_settings'
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
          'public gem pushes.'
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 3.2'

  spec.add_development_dependency('bundler', '~> 2.3')
  spec.add_development_dependency('bundler-audit', '>= 0')
  spec.add_development_dependency('config', '>= 3.0')
  spec.add_development_dependency('minitest', '~> 5.0')
  spec.add_development_dependency('rails', '>= 7.0')
  spec.add_development_dependency('rake', '~> 12.3')
  spec.add_development_dependency('rubocop', '>= 0')
  spec.add_development_dependency('rubocop-minitest', '>= 0')
  spec.add_development_dependency('rubocop-performance', '>= 0')
  spec.add_development_dependency('rubocop-rails', '>= 0')
  spec.add_development_dependency('rubocop-rake', '>= 0')
  spec.add_development_dependency('ruby_audit', '>= 0')
  spec.add_development_dependency('sqlite3', '>= 0')
  spec.add_development_dependency('temping', '~> 4.0')
  spec.add_runtime_dependency('activerecord', '> 4.2.0')
  spec.add_runtime_dependency('activesupport', '> 4.2.0')
  spec.metadata['rubygems_mfa_required'] = 'true'
end
