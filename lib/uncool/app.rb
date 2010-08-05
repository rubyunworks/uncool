require 'uncool/meta/data'
require 'uncool/trace'

module Uncool

  #
  class App

    #
    def initialize(options={})
      @options    = options
      @namespaces = options[:namespaces]
    end

    #
    attr :namespaces

    #
    alias_method :targets, :namespaces

    #
    attr :options

    #
    #def targets
    #  @targets ||= namespaces.map{ |ns| eval(ns, TOPLEVEL_BINDING) }
    #end

    #
    def trace
      @trace ||= Trace.new(targets, options)
    end

    #
    def analysis
      @analysis ||= Analysis.new(trace, options)
    end

    #
    def report
      @report ||= Report.new(analysis, options)
    end

    # This is the main method for activating hte trace and
    # recording the results.
    def log(logdir=nil)
      logdir = logdir || options[:output]
      trace.setup
      at_exit {
        trace.deactivate
        logdir ? report.save(logdir) : report.display
      }
      trace.activate
    end

    #
    def generate(scripts)
      require 'uncool/generator/ko'
      require 'uncool/generator/qed'
      require 'uncool/generator/lemon'

      generator = (
        case options[:framework]
        when :ko
          GeneratorKO.new(options)
        when :qed
          GeneratorQED.new(options)
        when :rspec
          #GeneratorRSpec.new(options)
        when :cuke, :cucumber
          #GeneratorCucumber.new(options)
        else
          GeneratorLemon.new(options)
        end
      )

      scripts.each{ |script| require(script) }

      generator.generate
    end

  end

end

