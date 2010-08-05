#if conf = Dir['{,.}config/uncool.yml'].first
#  require 'yaml'
#  opts = YAML.load(File.new(conf))
#  output     = opts['output'] || opts['out']
#  namespaces = opts['spaces'] || opts['namespaces'] || opts['ns']
#else
  output     = ENV['out']
  namespaces = ENV['ns'].split(',')
#end

require 'uncool/log'

Uncool.log(:output=>output, :namespaces=>namespaces)

