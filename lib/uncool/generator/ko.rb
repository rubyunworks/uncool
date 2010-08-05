require 'uncool/generator/abstract'

module Uncool

  # KO test generator.
  class GeneratorKO < GeneratorAbstract

    #
    def generate
      code = []
      mapping.each do |target, units|
        #next if /Lemon::Test::Suite/ =~ target.to_s
        code << "require 'lemon/syntax/ko'\n"
        code << "testcase #{target} do"
        units.each do |(unit, yes)|
          next if unit.covered? and !covered?
          next if unit.private? and !private?
          if unit.function?
            code << "\n  metaunit :#{unit.method} do\n\n  end"
          else
            code << "\n  unit :#{unit.method} do\n\n  end"
          end
        end
        code << "\nend\n"
      end
      code.join("\n")
    end

  end

end

