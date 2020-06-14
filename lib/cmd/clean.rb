require 'optparse'
require 'terminal-table'

module Cmd
  class CleanTasks
    def initialize(db)
      @db = db
    end

    def call(argv)
      parse(argv)
      @out || begin
        todos = @db[:todos].delete
        "Tasks cleaned up succesffully"
      end
    end

    private

    def parse(args)
      parser = OptionParser.new do |opts|
        opts.banner = "Usage: ineedto clean"

        opts.on("-h", "--help", "Show help and exit") do
          @out = opts.help
        end
      end
      parser.parse!(args)
    rescue OptionParser::ParseError => e
      raise CmdError, e.message
    end
  end
end
