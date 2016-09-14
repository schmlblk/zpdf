require 'thread'

module ZPdf

   class HtmlPdfObject

     attr_reader :html_parts
     attr_reader :pdf_content

     def self.wkhtmltopdf_path
       @@wkhtmltopdf_path ||= get_wkhtmltopdf_path
     end

     def self.get_wkhtmltopdf_path
       ZPdf::Base.wkhtmltopdf_path || find_wkhtmltopdf_executable # will try to call it anyway, if it is on the path
     end

     def initialize(html_parts = {},params = {})
       @html_parts = html_parts
       @params = params
       @verbose = params.delete('verbose')
     end

     def html_parts=(value)
       @html_parts = value
     end

     def pdf_content
       @pdf_content ||= convert_to_pdf
     end

     def save_to_file(filename)
       File.open(filename,'wb') { |f| f.write(pdf_content) }
     end

    protected

    def convert_to_pdf
      wk_params = @params.dup
      html_files = { :header  => make_temp_file_with_content(@html_parts[:header]),
                     :footer  => make_temp_file_with_content(@html_parts[:footer]),
                     :content => make_temp_file_with_content(@html_parts[:content]) }
      begin
        outfile_path = html_files[:content].path + '.pdf' # append correct extension to temp file name
        wk_params['header-html'] = html_files[:header].nil? ? nil : "file:///#{html_files[:header].path}"
        wk_params['footer-html'] = html_files[:footer].nil? ? nil : "file:///#{html_files[:footer].path}"
        wk_params['quiet']       = true

        cmd = "#{self.class.wkhtmltopdf_path}"
        wk_params.each_pair do |k,v|
          next if v.nil? || v === false
          cmd << (v == true ? " --#{k}" : " --#{k} #{v}")
        end

        cmd << " file:///#{html_files[:content].path} #{outfile_path}"
        puts "\n\nexecuting #{cmd}\n\n" if @verbose
        # TODO: check if errors can occur with systems where command processor is not UTF-8
        # if so, we could force encoding to something else
       `#{cmd}`
        if File.exists?(outfile_path)
          output = File.open(outfile_path,'rb') { |f| f.read }
          File.unlink(outfile_path)
        else
          raise ZPdf::RenderError.new("Error running wkhtmltopdf: #{cmd}")
        end
      ensure
        html_files.each_pair do |k,v|
          File.unlink(v.path)  if v && File.exists?(v.path) # make sure we delete our temporary files!
        end
      end
      output
    end

    # return an instance of File with a unique name, suitable for writing
    def create_temp_file(basename = '__pdf.html.object',ext = 'html',tmpdir = Dir::tmpdir,mode = 'wb')
      @@_temp_file_mutex ||= Mutex.new

       failures = n = 0
       begin
         @@_temp_file_mutex.lock
         begin
           tmpname = File.join(tmpdir, sprintf('%s.%d.%d.%s', basename, $$, n, ext))
           n += 1
         end while File.exists?(tmpname)
         return File.open(tmpname,mode)
       rescue
         failures += 1
         retry if failures < 10
         raise ZPdf::RenderError.new("ZPdf::HtmlPdfObject cannot create temp file")
       ensure
         @@_temp_file_mutex.unlock
       end
    end

    def make_temp_file_with_content(content)
      unless content.nil? || content.to_s.empty?
        f = create_temp_file
        f.write(content)
        f.flush
        f.close
        f
      end
    end

    def self.find_wkhtmltopdf_executable
      rbCfg = RbConfig
      if rbCfg::CONFIG['host_os'] =~ /mswin|mingw/ # windows?
        ENV['PATH'].split(';').each do |p|
          exec_path = File.join(p,'wkhtmltopdf.exe')
          return exec_path if File.exists?(exec_path)
        end
        return 'wkhtmltopdf.exe'
      else # *nix
        exec_path = `which wkhtmltopdf`.to_s.strip
        return File.exists?(exec_path) ? exec_path : 'wkhtmltopdf'
      end
    end

   end

end
