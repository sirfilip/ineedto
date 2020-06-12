require 'optparse'
require 'terminal-table'

module Cmd
  class ListTasks
    def initialize(db, logger, stdout, stderr)
      @db = db
      @logger = logger
      @stdout = stdout
      @stderr = stderr
    end

    def call(argv)
      _ = parse(argv)
      todos = @db[:todos].all
      table = Terminal::Table.new do |t|
        t.headings = ["ID", "Priority", "Name", "Done", "Due Date", "Completed On"]
        todos.each do |todo|
          t.add_row [todo[:id], todo[:priority], todo[:name], todo[:done], todo[:due_date].strftime(DATE_FORMAT), todo[:completed_on] && todo[:completed_on].strftime(DATE_FORMAT)]
        end
      end

      @stdout.puts(table)
    end

    private

    def parse(args)
      options = {}
      parser = OptionParser.new do |opts|
        opts.banner = "Usage: todo list"

        opts.on("-h", "--help", "Show help and exit") do
          @stdout.puts opts
          exit(0)
        end
      end
      parser.parse!(args)
      options
    rescue => e
      @stderr.puts e.message
      @stderr.puts parser
      exit(1)
    end
  end
end
