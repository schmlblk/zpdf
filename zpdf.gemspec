rails_version = '3.0.3'

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'zpdf'
  s.version     = '0.0.2'
  s.summary     = 'HTML-based PDF rendering engine (using wkhtmltopdf)'
  # s.description = ''
  s.required_ruby_version = '>= 1.9.2'

  s.author              = 'Charles Bedard'
  s.email               = 'charles@cbedard.net'
  s.homepage            = 'http://github.com/schmlblk/zpdf'
  # s.rubyforge_project = 'zpdf'

  s.files               = Dir['CHANGELOG', 'README.rdoc', 'lib/**/*']
  s.require_path        = 'lib'

  # s.has_rdoc = false

  s.add_dependency('rake',          '>= 0.8.7')
  s.add_dependency('actionpack',    ">= #{rails_version}")
  s.add_dependency('expectations',  ">= 2.0.0")
end
