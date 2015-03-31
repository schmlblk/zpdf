require 'iconv'

# USAGE:
#  This module provides basic methods to send PDF content. Simply include this module
#  in your controller(s):
#
#  class InvoiceController < ApplicationController
#     include PdfControllerMethods
#     ....

#      def show
#         ...
#         respond_to do |format|
#           ....
#           format.pdf {
#             send_pdf_content(InvoiceGenerator.invoice(@invoice).pdf_content,
#                             :file_name => 'invoice.pdf', :force_download => true)
#           }
#           ....
#         end
#      end
#  end
#

module PdfControllerMethods

#  uncomment and implement if you want to add custom functionality when this module is
#  included.
#  def self.included(base)
#    base.class_eval <<-EOV
#      def do_something_when_pdf_controller_methods_are_included
#      end
#    EOV
#  end

  protected
  # convert a file name to ISO-8859-1, so that all browsers correctly parse it.
  def sanitize_file_name(name)
     c = Iconv.new('ISO-8859-15','UTF-8')
     s = c.iconv(name.gsub(/[—–]/,'-'))
     s.gsub!(/^.*(\\|\/)/, '')
     s.gsub(/[\:\*\?\"\<\>\|]/, '_')
  end

  def send_pdf_content(pdf_content,options = {})
     force_download = options[:force_download] || false
     file_name = options[:file_name] || self.class.name.underscore
     # content type is 'iso-8859-1' because we want the header values (namely the filename) to
     # be interpreted as such.
     headers["Content-Type"] ||= 'application/pdf; charset=iso-8859-1'
     if force_download
       headers["Content-Disposition"] = "attachment; filename=\"#{sanitize_file_name(file_name)}\""
     end
     render :text => pdf_content, :layout => false
  end

end
