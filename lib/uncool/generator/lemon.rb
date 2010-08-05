require 'uncool/generator/abstract'

module Uncool

  # Lemon test generator.
  class GeneratorLemon < GeneratorAbstract

    #
    def generate
      code = []
      mapping.each do |target, units|
        #next if /Lemon::Test::Suite/ =~ target.to_s
        code << "TestCase #{target} do"
        units.each do |unit|
          next if unit.covered? and !covered?
          next if unit.private? and !private?
          if unit.function?
            code << "\n  MetaUnit :#{unit.method} => '' do\n\n  end"
          else
            code << "\n  Unit :#{unit.method} => '' do\n\n  end"
          end
        end
        code << "\nend\n"
      end
      code.join("\n")
    end

  end

end

