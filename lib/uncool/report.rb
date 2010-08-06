module Uncool

  #
  class Report

    #
    def initialize(analysis, options={})
      @analysis = analysis
      @options  = options
    end

    #
    def options
      @options
    end

    #
    def coverage
      @analysis.coverage
    end

    #
    def render
      require 'erb'
      rhtml = File.read(File.dirname(__FILE__) + '/report.rhtml')
      ERB.new(rhtml).result(binding)
    end

    #
    def save(logpath)
      require 'fileutils'
      dir  = File.join(logpath, 'uncool')
      file = File.join(dir, 'index.html')
      FileUtils.mkdir_p(dir)
      File.open(file, 'w'){ |w| w << render }
      $stderr.puts "Saved Uncool report at #{dir}."
    end

    #
    def display(format=nil)
      case options[:format]
      when 'tap'
        display_tap
      else
        display_color
      end
    end

    #
    def display_color
      require 'ansi'
      puts "\nUnit Coverage"
      i = 0
      coverage.uniq.sort.each do |unit|
        i += 1
        if unit.covered?
          puts "+ " + unit.to_s.ansi(:green)
        else
          puts "- " + unit.to_s.ansi(:red)
        end
      end
      puts
    end

    #
    def display_tap
      i = 0
      coverage.uniq.sort.each do |unit|
        i += 1
        if unit.covered?
          puts "ok #{i} - " + unit.to_s
        else
          puts "not ok #{i} - " + unit.to_s
        end
      end
    end

  end

end
