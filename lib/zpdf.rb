zpdf_path = File.expand_path(File.dirname(__FILE__))
$:.unshift(zpdf_path) if File.directory?(zpdf_path) && !$:.include?(zpdf_path)

require 'rails'
require 'active_support/core_ext/module/attr_internal'
require 'active_support/lazy_load_hooks'
require 'abstract_controller'
require 'action_view'
require 'z_pdf/version'
require 'z_pdf/railtie'

module ZPdf
  extend ::ActiveSupport::Autoload

#  autoload :AdvAttrAccessor
#  autoload :Collector
  autoload :Base
#  autoload :DeliveryMethods
#  autoload :DeprecatedApi
#  autoload :MailHelper
#  autoload :OldApi
#  autoload :TestCase
#  autoload :TestHelper
end

