require 'uncool/unit'
require 'uncool/report'

module Uncool

  #
  class Analysis

    #
    def initialize(trace, options={})
      @trace   = trace
      @private = options[:private]
    end

    #
    def log
      @trace.log
    end
    
    #
    def targets
      @trace.targets.map do |t|
        eval(t, TOPLEVEL_BINDING)
      end
    end

    #
    def private?
      @private
    end

    # Return a list of units that were covered.
    def coverage
      @coverage ||= (
        list = []
        log.each do |object, method|
          unit = Unit.new(object.class, method, :covered=>true)
          list << unit
        end
        list
      )
    end

    # Returns a list of all possible coverage points.
    def checklist
      coverage = []
      targets.each do |target|
        target.instance_methods(false).each do |meth|
          unit = Unit.new(target, meth)
          coverage << unit
        end

        target.methods(false).each do |meth|
          unit = Unit.new(target, meth, :function=>true)
          coverage << unit
        end

        if private?
          target.protected_instance_methods(false).each do |meth|
            unit = Unit.new(target, meth, :access=>:protected)
            coverage << unit
          end
          target.private_instance_methods(false).each do |meth|
            unit = Unit.new(target, meth, :access=>:private)
            coverage << unit
          end

          target.protected_methods(false).each do |meth|
            unit = Unit.new(target, meth, :access=>:protected, :function=>true)
            coverage << unit
          end
          target.private_methods(false).each do |meth|
            unit = Unit.new(target, meth, :access=>:private, :function=>true)
            coverage << unit
          end
        end
      end
      coverage
    end

    #
    #def save(logdir)
    #  Report.new(chart).save(logdir)
    #end

  end

end

