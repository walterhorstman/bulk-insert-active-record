# encoding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = 'bulk-insert-active-record'
  spec.version       = '0.0.5'
  spec.author        = ['Walter Horstman']
  spec.email         = ['walter.horstman@itonrails.com']

  spec.summary       = 'Lightweight bulk insert mechanism for ActiveRecord 3 or higher'
  spec.description   = 'This gem allows you to insert multiple rows as once, dramatically increasing performance.'
  spec.homepage      = 'https://github.com/walterhorstman/bulk-insert-active-record'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency('activerecord', '>= 3')
  spec.add_development_dependency('bundler', '~> 1.12')
  spec.add_development_dependency('rake')
  spec.add_development_dependency('rubocop')
end
