require 'rails/generators/base'
require 'rails/generators/erb'

module ZPdf
    module Generators
      class ProducerGenerator < Erb::Generators::Base
        source_root File.join(File.dirname(__FILE__),'templates')
      
        argument :actions, :type => :array, :default => [], :banner => "method method"
      
        def create_renderer_file
          template "producer_template.rb", File.join('app/pdf_producers', class_path, "#{file_name}.rb")
        end
        
        def create_view_files
          rails_root = Rails.root.to_s + "/"
          config = Rails.application.config
          paths  = Rails.application.paths
          pdf_views_path = ( (config.zpdf ? config.zpdf.pdf_views_path : nil) || paths.app.views.to_a.first).gsub(rails_root,'')
          
          base_path = File.join(pdf_views_path,class_path,file_name)
          empty_directory base_path
          actions.each do |a|
            @action = a
            ['','_header','_footer'].each do |view_name|
              @path = File.join(base_path,filename_with_extensions("#{a}#{view_name}"))
              template "view_template#{view_name}.html.erb", @path
            end
          end
        end
        
      end
   end
end
