Gem::Specification.new do |spec|
  spec.name          = 'packs-specification'
  spec.version       = '0.0.8'
  spec.authors       = ['Gusto Engineers']
  spec.email         = ['dev@gusto.com']
  spec.summary       = 'The specification for packs in the `rubyatscale` ecosystem.'
  spec.description   = 'The specification for packs in the `rubyatscale` ecosystem.'
  spec.homepage      = 'https://github.com/rubyatscale/packs-specification'
  spec.license       = 'MIT'

  if spec.respond_to?(:metadata)
    spec.metadata['homepage_uri'] = spec.homepage
    spec.metadata['source_code_uri'] = 'https://github.com/rubyatscale/packs-specification'
    spec.metadata['changelog_uri'] = 'https://github.com/rubyatscale/packs-specification/releases'
    spec.metadata['allowed_push_host'] = 'https://rubygems.org'
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
          'public gem pushes.'
  end

  # Specify which files should be added to the gem when it is released.
  spec.files = Dir['README.md', 'lib/**/*']
  spec.require_paths = ['lib']
  spec.required_ruby_version = '>= 2.6'

  spec.add_dependency 'sorbet-runtime'

  spec.add_development_dependency 'bundler', '~> 2.2.16'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'sorbet'
  spec.add_development_dependency 'tapioca'
end
