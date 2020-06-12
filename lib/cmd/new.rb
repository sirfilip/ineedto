require 'optparse'
require 'json'
require 'date'

require 'dry-validation'

module Cmd
  class NewTaskContract < Dry::Validation::Contract
    schema do 
      required(:name).filled(:string, size?: 1..255)
      required(:priority).filled(:integer, gt?: 0)
      required(:due_date).filled(:date)
    end

    rule(:due_date) do 
      key.failure("Cannot be in the past :)") if value < Date.today
    end
  end

  class NewTask
    def initialize(db, logger, stdout, stderr)
      @db = db
      @logger = logger
      @stdout = stdout
      @stderr = stderr
      @contract = NewTaskContract.new
    end

    def call(args)
      options = parse(args)
      errors = @contract.(options).errors(full: true).to_h
      unless errors.empty?
        @stderr.puts errors.to_json
        return
      end
      options[:done] = false
      @db[:todos].insert(options)
      @stdout.puts "Task added successfully"
    rescue => e
      @logger.debug(e)
      @stderr.puts "Failed to add todo"
    end

    private

    def parse(args)
      options = {}
      parser = OptionParser.new do |opts|
        opts.banner = "Usage: todo new"

        opts.on("-h", "--help", "Prints this help") do
          puts opts
          exit
        end

        opts.on("-n", "--name NAME", "Task Name") do |name|
          options[:name] = name 
        end
        
        opts.on("-p", "--priority [N]", Integer, "Priority") do |priority|
          options[:priority] = priority || 1
        end

        opts.on("-d", "--due-date DUE_DATE", "Due date with format YYYY-MM-DD") do |due_date|
          options[:due_date] = Date.strptime(due_date, DATE_FORMAT)
        end
      end
      parser.parse(args)
      options
    rescue => e
      @stderr.puts("Failed to parse arguments")
      @logger.debug(e.message)
      exit(1)
    end
  end
end
