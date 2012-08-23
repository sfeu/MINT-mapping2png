require 'optparse'
require 'xml/xslt'
require 'graphviz'

module Mintmap2png
  class CLI
    def self.execute(stdout, arguments=[])

      # NOTE: the option -p/--path= is given as an example, and should be replaced in your application.

      options = {
        :path     => '~'
      }
      mandatory_options = %w(  )

      parser = OptionParser.new do |opts|
        opts.banner = <<-BANNER.gsub(/^          /,'')
          This application is wonderful because...

          Usage: #{File.basename($0)} [options]

          Options are:
        BANNER
        opts.separator ""
        opts.on("-p", "--path PATH", String,
                "This is a sample message.",
                "For multiple lines, add more strings.",
                "Default: ~") { |arg| options[:path] = arg }
        opts.on("-h", "--help",
                "Show this help message.") { stdout.puts opts; exit }
        opts.parse!(arguments)

        if mandatory_options && mandatory_options.find { |option| options[option.to_sym].nil? }
          stdout.puts opts; exit
        end
      end

      path = options[:path]

      stdout.puts "missing directory name" if ARGV.length != 2

      input_directory = Dir.new(ARGV[0])
      output_directory =  File.expand_path(ARGV[1])
      p output_directory
      mapping_files = []

      xslt = XML::XSLT.new()
      xslt.xsl =  File.expand_path(File.dirname(__FILE__)) + "/../MINT-mapping2png/mapping_to_dot.xsl"


      input_directory.entries.each do |file|
        if file =~ /\.xml$/
          mapping_files << file
          xslt.xml = input_directory.path+file
          dot_buffer = xslt.serve()

          g = GraphViz.parse_string( dot_buffer)
          if g
            out_file = file.sub /\.xml/,""
            g.output(:png => Dir.new(output_directory).path+"/#{out_file}.png")
            puts "#{file}"
          else
            puts "Skipped #{file}"
            end
        end
      end
    end
  end
end