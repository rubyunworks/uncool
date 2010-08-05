require 'uncool/unit'

module Uncool

  # Generator base class.
  class GeneratorAbstract

    def initialize(options={})
      @namespaces = options[:namespaces] || []
      @checklist  = options[:checklist]
      @options    = options || {}
    end

    #
    def namespaces
      @namespaces
    end

    #
    def checklist
      @checklist ||= default_checklist
    end

    #
    def targets
      @targets ||= namespaces.map{ |ns| eval(ns, TOPLEVEL_BINDING) }
    end

    #
    def options
      @options
    end

    # Include already covered methods.
    def covered?
      options[:covered]
    end

    # Include private and protected methods?
    def private?
      options[:private]
    end

    #
    def mapping
      checklist.sort.group_by{ |mp, yes| mp.target }
    end

    # Override this method in subclasses.
    def generate
    end

    #
    def default_checklist
      list = []
      targets.each do |target|
        target.public_instance_methods(false).each do |meth|
          list << Unit.new(target, meth)
        end
        if private?
          target.protected_instance_methods(false).each do |meth|
            list << Unit.new(target, meth, :access=>:protected)
          end
          target.private_instance_methods(false).each do |meth|
            list << Unit.new(target, meth, :access=>:private)
          end
        end
      end
      list
    end

  end

end


#
#    # Generate code template.
#    #
#    def generate
#      code = []
#      system.each do |ofmod|
#        next if ofmod.base.is_a?(Lemon::Test::Suite)
#        code << "TestCase #{ofmod.base} do"
#        ofmod.class_methods(public_only?).each do |meth|
#          code << "\n  MetaUnit :#{meth} => '' do\n    raise Pending\n  end"
#        end
#        ofmod.instance_methods(public_only?).each do |meth|
#          code << "\n  Unit :#{meth} => '' do\n    raise Pending\n  end"
#        end
#        code << "\nend\n"
#      end
#      code.join("\n")
#    end

