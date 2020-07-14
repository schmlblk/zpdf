rails_version = '6.0'

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'zpdf'
  s.version     = '6.0.0'
  s.summary     = 'HTML-based PDF rendering engine (using wkhtmltopdf)'
  s.description = 'ZPdf allows to produce PDF content based on ERB templates. It easily integrates into a Rails application and operates on a paradigm very similar to Rails ActionMailer.'
  s.license     = 'MIT'
  s.homepage    = 'https://github.com/schmlblk/zpdf'
  s.authors     = ['Charles Bedard', 'Stephane Volet']
  s.email       = ['zzeligg@gmail.com', 'steph@zboing.ca']
  s.date        = '2020-07-13'

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.files        = Dir['CHANGELOG.md', 'README.rdoc', 'lib/**/*']

  s.required_ruby_version = Gem::Requirement.new(">= 2.5.0".freeze)

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency('activesupport', "~> #{rails_version}")
    s.add_runtime_dependency('actionpack',    "~> #{rails_version}")
    s.add_runtime_dependency('actionview',    "~> #{rails_version}")
  else
    s.add_dependency('activesupport', "~> #{rails_version}")
    s.add_dependency('actionpack',    "~> #{rails_version}")
    s.add_dependency('actionview',    "~> #{rails_version}")
  end
end
