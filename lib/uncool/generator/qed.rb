require 'uncool/generator/abstract'

module Uncool

  # QED test generator.
  class GeneratorQED < GeneratorAbstract

    #
    def generate
      code = []
      mapping.each do |target, units|
        #next if /Lemon::Test::Suite/ =~ target.to_s
        code << "= #{target}\n"
        units.each do |(unit, yes)|
          next if unit.covered? and !covered?
          next if unit.private? and !private?
          if unit.function?
            code << "== ::#{unit.method}\n\n"
          else
            code << "== ##{unit.method}\n\n"
          end
        end
      end
      code.join("\n")
    end

  end

end

