require 'optparse'

module Cmd
  class Root
    def initialize(logger, stdout, stderr)
      @logger = logger
      @stdout = stdout
      @stderr = stderr
    end

    def call(args)
      parser = OptionParser.new do |opts|
        opts.banner = "Usage: todo [new|complete|list|pending|completed|today|search]"

        opts.on("-h", "--help", "Prints this help") do
          @stdout.opts
          exit
        end

        opts.on("-v", "--version", "Prints version") do
          @stdout.puts VERSION
          exit
        end
      end
      parser.parse!(args)
      @stdout.puts parser
    end
  end
end
