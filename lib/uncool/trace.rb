require 'rubygems'
gem('tracepoint')

require 'tracepoint'
require 'uncool/analysis'

module Uncool

  #
  class Trace

    #
    attr :targets

    #
    attr :log

    #
    def initialize(targets, options={})
      @targets = [targets].compact.flatten
      @options = options
      @log = []
    end

    #
    def setup
      tracker = self
      TracePoint.trace do |tp|
        #puts "#{tp.self.class}\t#{tp.callee}\t#{tp.event}\t#{tp.return?}"
        if tp.event == 'call' or tp.event == 'c-call'
          if tracker.target?(tp.self.class)
            tracker.log << [tp.self, tp.callee]
          end
        end
      end
    end

    #
    def target?(mod)
      return true if targets.empty?
      targets.find do |target|
        begin
          target_class = eval(target, TOPLEVEL_BINDING) #Object.const_get(target)
        rescue
          nil
        else
          target_class == mod
        end
      end
    end

    #
    def activate
      setup
      TracePoint.activate
    end

    #
    def deactivate
      TracePoint.deactivate
    end

    #
    def to_analysis
      Analysis.new(self, @options)
    end

  end

end
