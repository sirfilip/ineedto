require_relative 'cmd/root'
require_relative 'cmd/new'
require_relative 'cmd/list'
require_relative 'cmd/complete'
require_relative 'cmd/pending'
require_relative 'cmd/completed'
require_relative 'cmd/search'
require_relative 'cmd/today'
require_relative 'cmd/clean'

module Cmd
  class CmdError < StandardError; end

  VERSION = "0.0.2"
  DATE_FORMAT = "%Y-%m-%d"
end
