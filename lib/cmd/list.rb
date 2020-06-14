require 'optparse'
require 'terminal-table'

module Cmd
  class ListTasks
    def initialize(db)
      @db = db
    end

    def call(argv)
      parse(argv)
      @out || begin
        todos = @db[:todos].all
        table = Terminal::Table.new do |t|
          t.headings = ["ID", "Priority", "Name", "Done", "Due Date", "Completed On"]
          todos.each do |todo|
            t.add_row [todo[:id], todo[:priority], todo[:name], todo[:done], todo[:due_date].strftime(DATE_FORMAT), todo[:completed_on] && todo[:completed_on].strftime(DATE_FORMAT)]
          end
        end

        table
      end
    end

    private

    def parse(args)
      parser = OptionParser.new do |opts|
        opts.banner = "Usage: ineedto list"

        opts.on("-h", "--help", "Show help and exit") do
          @out = opts.help
        end
      end
      parser.parse!(args)
    rescue => e
      raise CmdError, e.message
    end
  end
end
