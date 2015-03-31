# zpdf

ZPdf allows to produce PDF content based on ERB templates. It easily integrates
into a Rails 3 application and operates on a paradigm very similar to 
Rails 3 ActionMailer.

As such it implements a subclass of AbstractController, and uses the excellent
HTML to PDF converter named wkhtmltopdf:

http://code.google.com/p/wkhtmltopdf/

## Requirements

 * wkhtmltopdf 0.9.6 or later
 * Rails 3.0.3 or later

## Creating PDF documents

PDF producers are placed in app/pdf_producers and will be automatically loaded
where referenced in your Rails application.

```ruby
class PdfProducer < ZPdf::Base
  def invoice(invoice)
    @invoice = invoice
    generate(:pdf_params => { 'outline' => true })
  end
end
```
The PDF content is created by producing an HTML document using an ActionView  
template (regular ERb) that has the instance variables that are declared in 
the producer action.

The `invoice` method in the above example could have a corresponding Erb 
template like this:

```rhtml
...
<h3>Invoice no: <%= @invoice.no %></h3>
  
<p>
  <%= @invoice.customer.first_name %>, <%= @invoice.customer.last_name %><br />
  <%= @invoice.customer.address %>
</p>
...
```

The ZPdf::Base#generate method takes a Hash of parameters. Possible values are:

  :header_template :  The file name of the Erb template to use to render the header 
                      section of all PDF pages. Can be nil.
  :header_template :  The file name of the Erb template to use to render the footer 
                      section of all PDF pages. Can be nil.
  :template_path   :  Use a directory other than the under_scored class name.
  :template_name   :  Use a template named other than the action name.                      
  :pdf_params      :  A Hash containing the command line parameters to be 
                      passed through to wkhtmltopdf. Note the keys are all 
                      strings. Boolean values are simply passed as their name, 
                      as wkhtmltopdf expects them.

Note that :header_template and :footer_template are first rendered into HTML 
documents and saved as temporary files which are then passed to wkhtmltopdf as 
the 'header-html' and 'footer-html' parameters (see wkhtmltopdf documentation).
This allows to use Erb to render their content. 

You could also omit the header and footer templates, but use pure HTML header 
and footer documents passed through directly by including their full path as 
the 'header-html' and 'footer-html' in the :pdf_params Hash.

Calling `generate` returns a instance of ZPdf::HtmlPdfObject, which has methods
for accessing and manipulating the produced HTML and convert it to a PDF stream:

```ruby
invoice_pdf = PdfProducer.invoice(Invoice.find(:first))
  
# access the HTML parts used for the PDF document
html_for_content = invoice_pdf.html_parts[:content]
  
# header and footer are full HTML documents which will be rendered as
# headers and footers on every page of the PDF document.
html_for_header = invoice_pdf.html_parts[:header]
html_for_footer = invoice_pdf.html_parts[:footer]
  
# get the actual PDF content. 
invoice_pdf.pdf_content
  
# or directly save the PDF content to file
invoice_pdf.save_to_file('invoice.pdf')
```

## Rails Generator for PDF Producers 

ZPdf comes with a Rails generator to quickly create the basis for a PDF 
producer:

```ruby
rails generate z_pdf:producer MyPdfProducer invoice receipt
```

This would create the file app/my_pdf_producer.rb with 2 stubbed methods, along
with 3 views for each method. The 3 views correspond to 3 possible parts of the
PDF document (content, header and footer). See the wkhtmltopdf documentation 
for header-html and footer-html parameters for more information.  
  
## In Rails Controllers

Using the provided rails generator:

```ruby
rails generate z_pdf:controller_module
```

This will create a module in lib/pdf_controller_methods.rb, which declares
a Module to be included in your controllers. The interesting method of that module
is #send_pdf_content, which can be used in a controller:

```ruby
class InvoicesController < ApplicationController
  include PdfControllerMethods
  
  def show
    @invoice = Invoice.find(params[:id])
    invoice_pdf = PdfGenerator.invoice(@invoice)
    respond_to do |format|
      format.html { render :text => invoice_pdf.html_parts[:content] }
      format.pdf { send_pdf_content(invoice_pdf.pdf_content) }
    end
  end
end
```

## Considerations for inclusion of Assets

It is important to remember that wkhtmltopdf references external assets (such 
as images, stylesheets and javascripts) as URLs. Your templates must therefore
specify full URLs (not relative ones), because it is run from the command line
and not within the Web context of your application.

Therefore, if you call the following:

```rhtml
<%= stylesheet_link_tag 'invoice.css' %>
```

wkhtmltopdf will not be able to resolve the relative url this creates. Instead,
you should either specify an absolute url, or include the stylesheet directly 
in a style tag:

```rhtml
<style type="text/css">
  <link rel="stylesheet" href="file://<%= raw File.join(Rails.root,'public/stylesheets/pdf.css') %>" />
  <%= raw File.open(File.join(Rails.root,'public/stylesheets/pdf.css')) { |f| f.read } %>
</style>
```

## Configuration

The Base class has the following settings:

```ruby
ZPdf::Base.config = {
  :pdf_views_path   => 'app/views' # defaults to 'app/views'
  :assets_dir       => 'public/'
  :javascripts_dir  => 'public/javascripts'
  :stylesheets_dir  => 'public/stylesheets'
  :wkhtmltopdf_path => 'wkhtmltopdf' # path to wkhtmltopdf executable 
} 
```

Because producing PDF from HTML may have nothing to do with the graphic style 
of your application as seen on the Web, the :pdf_views_path allows you to 
specify a base directory in which all PDF templates will reside. This allows to 
cleanly separate all your templates to produce PDF's from those used for your 
actual application pages. You could do the same with the assets, javascripts 
and stylesheets directories, by overriding the default values. If you do not 
change the :pdf_views_path, it will remain as the Rails default (app/views).

Either create an initializer in config/initializers or use application.rb to
specify the configuration values.

## Download and installation

TODO!

## License

TOCHOOSE!

## Support

API documentation is at TODO: SOMEWHERE

Bug reports and feature requests here:

* TODO: ADD URL FOR SUPPORT

