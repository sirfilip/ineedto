require 'optparse'

module Cmd
  class Root
    def call(args)
      parser = OptionParser.new do |opts|
        opts.banner = "Usage: ineedto [new|complete|list|pending|completed|today|search]"

        opts.on("-h", "--help", "Prints this help") do
          @out = opts.help
        end

        opts.on("-v", "--version", "Prints version") do
          @out = VERSION
        end
      end
      parser.parse!(args)
      @out || parser.help
    rescue OptionParser::ParseError => e
      raise CmdError, e.message
    end
  end
end
