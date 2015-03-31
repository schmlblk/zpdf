rails_version = '3.0.3'

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'zpdf'
  s.version     = '0.0.3'
  s.summary     = 'HTML-based PDF rendering engine (using wkhtmltopdf)'
  s.description = 'ZPdf allows to produce PDF content based on ERB templates. It easily integrates into a Rails 3 application and operates on a paradigm very similar to Rails 3 ActionMailer.'
  s.required_ruby_version = '>= 1.9.2'

  s.authors             = ['Charles Bedard', 'Stephane Volet']
  s.emails              = ['zzeligg@gmail.com', 'steph@zboing.ca']
  s.homepage            = 'https://rubygems.org/gems/zpdf'

  s.files               = Dir['CHANGELOG', 'README.rdoc', 'lib/**/*']
  s.require_path        = 'lib'

  s.has_rdoc = false

  s.add_dependency('rake',          '>= 0.8.7')
  s.add_dependency('actionpack',    ">= #{rails_version}")
  s.add_dependency('expectations',  ">= 2.0.0")
end
