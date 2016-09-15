require "zpdf"
require "rails"

module ZPdf
  class Railtie < Rails::Railtie
    config.zpdf = ActiveSupport::OrderedOptions.new
    config.eager_load_namespaces << ZPdf

    initializer "zpdf.set_configs" do |app|
      paths   = app.config.paths
      options = app.config.zpdf

      # by default, the views path for ZPdf::Base is the same as other views
      pdf_views_path = options.pdf_views_path || paths['app/views'].first

      ActiveSupport.on_load(:zpdf) do
        include app.routes.url_helpers
        append_view_path pdf_views_path
        options.each { |k,v|
          send("#{k}=", v)
        }
      end
    end

    generators do
      load File.expand_path('./generators/producers/producer.rb',File.dirname(__FILE__))
      load File.expand_path('./generators/controller_module/controller_module.rb',File.dirname(__FILE__))
    end

  end
end
