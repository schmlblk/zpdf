require 'zpdf/html_pdf_object'
require 'zpdf/zpdf_helper'

module ZPdf #:nodoc:
  #
  # Example:
  #
  #  class PdfInvoice < ZPdf::Base
  #
  #    def invoice(client)
  #      @client = client
  #      generate( :pdf_params => { 'page-size'  => 'Letter', 'margin-top' => 4, 'margin-bottom' => 9.5, 'outline' => true } )
  #    end
  #
  #
  class RenderError < StandardError
  end

  class MissingTemplate < RenderError
    def initialize(generator_class,view_paths,part_name,templates_path,template_name)
      paths = view_paths.compact.map{ |p| p.to_s.inspect }.join(", ")
      super("Missing #{part_name} template \"#{template_name}\" in \"#{templates_path}\" for #{generator_class.name} with view_paths: #{paths}")
    end
  end

  class Base < AbstractController::Base
    abstract!

    include AbstractController::Rendering
    include AbstractController::Helpers
    include AbstractController::Translation
    include AbstractController::AssetPaths
    include AbstractController::Logger

    include ActionView::Layouts

    helper ZPdf::PdfHelper

    private_class_method :new #:nodoc:

    class_attribute :default_params
    self.default_params = {
      :header_template => nil,
      :footer_template => nil
    }.freeze

    class_attribute :default_pdf_params
    self.default_pdf_params = { 'outline' => true }.freeze

    config_accessor :pdf_views_path, :wkhtmltopdf_path

    class << self

      def generator_name
        @generator_name ||= name.underscore
      end
      attr_writer :generator_name
      alias :controller_path :generator_name

      def default(value = nil)
        self.default_params = default_params.merge(value).freeze if value
        default_params
      end

      def default_pdf(value = nil)
        self.default_pdf_params = default_pdf_params.merge(value).freeze if value
        default_pdf_params
      end

      def respond_to?(method, *args)
        super || action_methods.include?(method.to_s)
      end

    protected

      def method_missing(method, *args) #:nodoc:
        if action_methods.include?(method.to_s)
          new(method, *args).html_pdf
        else
          super
        end
      end

    end # class << self

    attr_internal :html_pdf

    def initialize(method_name, *args)
      super()
      process(method_name, *args)
    end

    def process(*args) #:nodoc:
      lookup_context.skip_default_locale! if lookup_context.respond_to?(:skip_default_locale!)
      super
    end

    def generate(parameters={})
      render_html(parameters)
    end

  protected

    def render_html(parameters={})
      params = parameters.reverse_merge(self.class.default)
      html_parts = render_html_parts(params)
      pdf_params = (parameters[:pdf_params] || {}).reverse_merge(self.class.default_pdf)
      @_html_pdf = HtmlPdfObject.new(html_parts,pdf_params)
    end

    def render_html_parts(params) #:nodoc:
      parts = {}

      # TODO : support inline content
      templates_path = params.delete(:template_path) || self.class.generator_name
      template_names = { :content => params.delete(:template_name) || action_name,
                         :header  => params.delete(:header_template),
                         :footer  => params.delete(:footer_template) }
      template_names.each_pair do |part_name,template_name|
        unless template_name.nil?
          if template = lookup_context.find_all(template_name,templates_path).first
            parts[part_name] = render(:template => template)
          else
            raise MissingTemplate.new(self.class,lookup_context.view_paths,part_name,templates_path,template_name)
          end
        end
      end
      parts
    end

    ActiveSupport.run_load_hooks(:zpdf, self)
  end
end
