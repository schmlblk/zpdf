
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

  protected

  # convert a file name to ISO-8859-1, that most browsers parse correctly.
  def sanitize_file_name(name)
    # NOTE: We could use ActiveSupport::Inflector#transliterate also, but that would remove diacritics also...
    name.gsub! /^.*(\\|\/)/, ''
    name.gsub! /[\:\*\?\"\<\>\|]/, '_'
    name.gsub! "—", "-"
    return name.encode('ISO-8859-1', :invalid => :replace, :undef => :replace, :replace => '_')
  end

  def send_pdf_content(pdf_content,options = {})
    force_download = options[:force_download] || false
    file_name = options[:file_name] || self.class.name.underscore
    headers["Content-Type"] ||= 'application/pdf; charset=iso-8859-1'
    headers["Content-Disposition"] = "#{force_download ? 'attachment' : 'inline'}; filename=\"#{sanitize_file_name(file_name)}\""
    render :text => pdf_content, :layout => false
  end

end
