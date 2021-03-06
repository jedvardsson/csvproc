require 'optparse'
require 'csv'


module CSVProc

    PROG_NAME = 'csvproc'

    @opt_parsers = {
        'global' => OptionParser.new do |opts|
        opts.banner = "Usage: #{PROG_NAME} [options] command [cmd_options]

commands:
    help            shows help for a command
    keyval  	    converts csv to key=value. First line of file contains key names.
                    Escapes \\n, \\r, \\f, and \\ with backslash.
        "
            opts.on('-h', '--help', 'Show help') do
                puts opts
                exit
            end
        end,

        'keyval' => OptionParser.new do |opts|
            opts.banner = "Usage: #{PROG_NAME} keyval CSVFILE..."
        end,
    }

    def self.cmd_help()
        if ARGV.size == 0
            puts @opt_parsers['help']
        else
            puts @opt_parsers[ARGV[0]]
        end
    end

    def self.parse_cmdline()
        @opt_parsers['global'].parse!
        command = ARGV.shift

        if !command
            puts @opt_parsers['global']
            exit
        end

        raise "Unknown command: #{command}"  if !@opt_parsers.key?(command)

        @opt_parsers[command].parse!
        send('cmd_' + command)
    end

    def self.cmd_keyval()
        ARGV.each do |f|
            first = true
            csv = CSV.foreach(f, :headers => :first_row) do |row|
                if !first
                    puts '-'*8
                end
                first = false
                row.each do | (k, v) |
                    puts "#{escape(k)}=#{escape(v)}"
                end
            end
        end
    end

    @h = {
            "\\" => Regexp.escape("\\\\"),
            "\n" => Regexp.escape("\n"),
            "\r" => Regexp.escape("\r"),
            "\f" => Regexp.escape("\f"),
    }

    def self.escape(s)
        return nil unless s
        s.gsub(/\\|\n/) { |m|
            @h[m]
        }
    end

    begin
        parse_cmdline
    rescue Errno::EPIPE
    end


end # module
