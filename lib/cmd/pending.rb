
require 'optparse'
require 'terminal-table'

module Cmd
  class PendingTasks
    def initialize(db)
      @db = db
    end

    def call(argv)
      parse(argv)
      @out || begin
        todos = @db[:todos].where(done: false).all
        table = Terminal::Table.new do |t|
          t.headings = ["ID", "Priority", "Name", "Done", "Due Date"]
          todos.each do |todo|
            t.add_row [todo[:id], todo[:priority], todo[:name], todo[:done], todo[:due_date].strftime(DATE_FORMAT)]
          end
        end

        table
      end
    end

    private

    def parse(args)
      parser = OptionParser.new do |opts|
        opts.banner = "Usage: ineedto pending"

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
