$LOAD_PATH.push File.expand_path('../lib', __FILE__)

require 'bookkeeper/version'

Gem::Specification.new do |s|
  s.platform      = Gem::Platform::RUBY
  s.name          = 'bookkeeper'
  s.version       = Bookkeeper::VERSION
  s.summary       = 'Bookkeeper is an Accounting module with Double Entry Book Keeping system.'
  s.description   = 'Bookkeeper is an Accounting module with Double Entry Book Keeping system.'

  s.authors       = ['Angel Aviel Domaoan']
  s.email         = %w(angelaviel.domaoan@gmail.com)
  s.license       = 'MIT'

  s.files         = Dir['{app,config,db,lib}/**/*', 'LICENSE', 'Rakefile', 'README.md']
  s.test_files    = Dir['{spec}/**/*']

  s.add_dependency 'rails', '~> 5.0'
  s.add_dependency 'highline', '~> 1.6.18' # Necessary for the install generator
end
