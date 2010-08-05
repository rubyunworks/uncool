module Uncool

  require 'optparse'

  # CLI Interface handle all lemon sub-commands.
  class CLI

    COMMANDS = ['coverage', 'generate']

    #
    def self.run(argv=ARGV)
      new.run(argv)
    end

    #
    def initialize(argv=ARGV)
      @options = {}
    end

    #
    def options
      @options
    end

    #
    def run(argv)
      if argv.include?('-g') or argv.include?('--generate')
        cmd = 'generate'
      else
        cmd = 'coverage'
      end
      cmd = COMMANDS.find{ |c| /^#{cmd}/ =~ c }
      __send__("#{cmd}_parse", argv)
      __send__("#{cmd}", argv)
    end

    # C O V E R A G E

    #
    def coverage(scripts)
      require 'uncool/app'

      app = App.new(options)

      app.log

      scripts.each do |file|
        require(file)
      end
    end

    #
    def coverage_parse(argv)
      option_namespaces
      option_private
      option_output
      option_format
      #option_uncovered
      option_loadpath
      option_requires

      option_parser.parse!(argv)
    end

    # G E N E R A T E

    #
    def generate(scripts)
      require 'uncool/app'

      app = App.new(options)

      output = app.generate(scripts)

      $stdout.puts(output)
    end

    #
    def generate_parse(argv)
      option_generate
      option_namespaces
      option_framework
      option_private
      option_loadpath
      option_requires

      option_parser.parse!(argv)
    end

    # P A R S E R  O P T I O N S

    def option_namespaces
      option_parser.on('-n', '--namespace NAME', 'add a namespace to output') do |name|
        options[:namespaces] ||= []
        options[:namespaces] << name
      end
    end

    def option_framework
      option_parser.on('-f', '--framework NAME', 'framework syntax to output') do |name|
        options[:framework] = name.to_sym
      end
    end

    # TODO: How feasible is it to parse tests of various frameworks to check "writ" coverage?
    #def option_uncovered
    #  option_parser.on('-u', '--uncovered', 'include only uncovered tests') do
    #    options[:uncovered] = true
    #  end
    #end

    def option_private
      option_parser.on('-p', '--private', 'include private and protected methods') do
        options[:private] = true
      end
    end

    def option_output
      option_parser.on('-o', '--output DIRECTORY', 'log directory') do |dir|
        options[:output] = dir
      end
    end

    def option_format
      option_parser.on('--format', '-f NAME', 'output format') do |name|
        options[:format] = name
      end
    end

    def option_loadpath
      option_parser.on("-I PATH" , 'add directory to $LOAD_PATH') do |path|
        paths = path.split(/[:;]/)
        options[:loadpath] ||= []
        options[:loadpath].concat(paths)
      end
    end

    def option_requires
     option_parser.on("-r FILE" , 'require file(s) (before doing anything else)') do |files|
        files = files.split(/[:;]/)
        options[:requires] ||= []
        options[:requires].concat(files)
      end
    end

    def option_generate
      option_parser.on('-g' , '--generate', 'code generation mode') do
      end
    end

    def option_parser
      @option_parser ||= (
        OptionParser.new do |opt|
          opt.on_tail("--debug" , 'turn on debugging mode') do
            $DEBUG = true
          end
          opt.on_tail('-h', '--help', 'display this help messae') do
            puts opt
            exit 0
          end
        end
      )
    end

  end

end

