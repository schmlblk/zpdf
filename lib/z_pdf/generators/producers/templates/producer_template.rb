class <%= class_name %> < ZPdf::Base
  default_pdf 'outline' => true, 'page-size' => 'Letter'
<% for action in actions -%>

  def <%= action %>
    generate :header_template => "<%= action %>_header",
             :footer_template => "<%= action %>_footer",
             :pdf_params => { 'margin-top' => 4, 'margin-bottom' => 4 }
  end
<% end -%>
end
