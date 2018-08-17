lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'semlogr/rack/version'

Gem::Specification.new do |spec|
  spec.name          = 'semlogr-rack'
  spec.version       = Semlogr::Rack::VERSION
  spec.authors       = ['Stefan Sedich']
  spec.email         = ['stefan.sedich@gmail.com']

  spec.summary       = 'Semlogr integration for rack.'
  spec.description   = 'Semlogr integration for rack providing features such as request logging.'
  spec.homepage      = 'https://github.com/semlogr/semlogr-rack'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'semlogr', '~> 0.3'

  spec.add_development_dependency 'bundler', '~> 1.13'
  spec.add_development_dependency 'pry', '~> 0.11'
  spec.add_development_dependency 'rake', '~> 12.3'
  spec.add_development_dependency 'rspec', '~> 3.7'
  spec.add_development_dependency 'rubocop', '~> 0.53'
end
