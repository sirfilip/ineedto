require 'optparse'
require 'terminal-table'

require 'sequel'

module Cmd
  class SearchTasks
    def initialize(db, logger, stdout, stderr)
      @db = db
      @logger = logger
      @stdout = stdout
      @stderr = stderr
    end

    def call(argv)
      options = parse(argv)
      todos = @db[:todos].where(Sequel.ilike(:name, "%#{options[:q]}%")).all
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
        opts.banner = "Usage: todo search"

        opts.on("-h", "--help", "Show help and exit") do
          @stdout.puts opts
          exit(0)
        end

        opts.on("-q", "--query [QUERY]", "Search tasks using q") do |q|
          options[:q] = q || ""
        end
      end
      parser.parse!(args)
      options
    end
  end
end

