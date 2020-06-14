require 'optparse'


module Cmd
  class CompleteTask
    def initialize(db)
      @db = db
    end

    def call(args)
      options = parse(args)
      @out || begin 
        todo = @db[:todos].where(id: options[:id]).first
        if todo.nil?
          "Not found"
        else
          @db[:todos].where(id: options[:id]).update(done: true, completed_on: Date.today)
          "Task completed"
        end
      end
    end

    private

    def parse(args)
      options = {}
      parser = OptionParser.new do |opts|
        opts.banner = "Usage: ineedto complete"

        opts.on("--h", "--help", "Show this help and exit") do
          @out = opts.help
        end

        opts.on("-t ID", "--task ID", Integer, "Task to complete") do |id|
          options[:id] = id
        end
      end
      parser.parse!(args)
      options
    rescue OptionParser::ParseError => e
      raise CmdError, e.message
    end
  end
end
