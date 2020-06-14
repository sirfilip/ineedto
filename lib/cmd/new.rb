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
    def initialize(db)
      @db = db
      @contract = NewTaskContract.new
      @out = nil
    end

    def call(args)
      options = parse(args)
      @out || begin 
        errors = @contract.(options).errors(full: true).to_h
        unless errors.empty?
          table = Terminal::Table.new do |t|
            errors.each do |field, errors|
              row = []
              row.push(field)
              errors.each do |err|
                row.push(err)
              end
              t.add_row(row)
            end
          end
          "Failed to create task\n" + table.to_s
        else
          options[:done] = false
          @db[:todos].insert(options)
          "Task added successfully"
        end
      end
    rescue OptionParser::ParseError => e
      raise CmdError, e.message
    end

    private

    def parse(args)
      options = {}
      parser = OptionParser.new do |opts|
        opts.banner = "Usage: ineedto new"

        opts.on("-h", "--help", "Prints this help") do
          @out = opts.help
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
    rescue OptionParser::ParseError => e
      raise CmdError, e.message
    end
  end
end
