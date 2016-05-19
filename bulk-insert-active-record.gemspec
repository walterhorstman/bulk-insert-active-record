# encoding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name                  = 'bulk-insert-active-record'
  spec.summary               = 'Lightweight bulk insert mechanism for ActiveRecord 3 or higher'
  spec.description           = 'This gem allows you to insert multiple rows as once, dramatically increasing performance.'
  spec.version               = '0.0.3'
  spec.required_ruby_version = '>= 1.9.2'

  spec.author                = 'Walter Horstman'
  spec.email                 = 'walter.horstman@itonrails.com'
  spec.homepage              = 'https://github.com/walterhorstman/bulk-insert-active-record'

  spec.files                 = `git ls-files -z`.split("\x0")
  spec.executables           = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files            = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_path          = 'lib'

  spec.add_dependency('activerecord', '>= 3')
end
