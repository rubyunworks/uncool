require 'uncool/app'

module Uncool

  # Run coverage trace and log results.
  #
  #  targets = ENV['squeeze'].split(',')
  #  Lemon.log(targets, :output=>'log')
  #
  # NOTE: This sets up an at_exit routine.
  def self.log(options={})
    app = App.new(options)
    app.log
  end

end

