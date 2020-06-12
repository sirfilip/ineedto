require 'optparse'


module Cmd

  class CompleteTask
    def initialize(db, logger, stdout, stderr)
      @db = db
      @logger = logger
      @stdout = stdout
      @stderr = stderr
    end

    def call(args)
      options = parse(args)
      todo = @db[:todos].where(id: options[:id]).first
      if todo.nil?
        @stderr.puts "Not found"
        exit(1)
      end
      @db[:todos].where(id: options[:id]).update(done: true, completed_on: Date.today)
      @stdout.puts "Todo completed"
    end

    private

    def parse(args)
      options = {}
      parser = OptionParser.new do |opts|
        opts.on("--h", "--help", "Show this help and exit") do
          @stdout.puts opts
          exit(0)
        end

        opts.on("-t ID", "--task ID", Integer, "Task to complete") do |id|
          options[:id] = id
        end
      end
      parser.parse!(args)
      options
    end
  end
end
