rails_version = '4.1.0'

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'zpdf'
  s.version     = '4.1.7'
  s.summary     = 'HTML-based PDF rendering engine (using wkhtmltopdf)'
  s.description = 'ZPdf allows to produce PDF content based on ERB templates. It easily integrates into a Rails application and operates on a paradigm very similar to Rails ActionMailer.'

  s.required_ruby_version = '>= 2.0.0'

  s.authors             = ['Charles Bedard', 'Stephane Volet']
  s.email               = ['zzeligg@gmail.com', 'steph@zboing.ca']
  s.homepage            = 'https://rubygems.org/gems/zpdf'
  s.license             = 'MIT'

  s.files               = Dir['CHANGELOG.md', 'README.rdoc', 'lib/**/*']
  s.require_path        = 'lib'

  s.has_rdoc = false

  s.add_dependency('rake',          '>= 0.8.7')
  s.add_dependency('actionpack',    ">= #{rails_version}", '< 6.0.0')
  s.add_dependency('actionview',    ">= #{rails_version}", '< 6.0.0')
end
