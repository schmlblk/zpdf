zpdf_path = File.expand_path(File.dirname(__FILE__))
$:.unshift(zpdf_path) if File.directory?(zpdf_path) && !$:.include?(zpdf_path)

require 'active_support/rails'
require 'active_support/core_ext/module/attr_internal'
require 'active_support/lazy_load_hooks'
require 'abstract_controller'
require 'action_view'
require 'zpdf/version'
require 'zpdf/railtie'

module ZPdf
  extend ::ActiveSupport::Autoload

  autoload :Base, 'zpdf/base'
end

