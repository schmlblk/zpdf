require 'rails/generators/base'

module ZPdf
  module Generators
    class ControllerModuleGenerator < Rails::Generators::Base
      source_root File.join(File.dirname(__FILE__),'templates')

      def create_controller_module
        template "controller_module_template.rb", 'app/controllers/concerns/pdf_controller_methods.rb'
      end
    end
  end
end
