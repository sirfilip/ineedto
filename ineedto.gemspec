# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cmd'

Gem::Specification.new do |s|
  s.name = 'ineedto'
  s.version = Cmd::VERSION
  s.date = '2020-06-14'
  s.summary = 'Simple cmd task organizer'
  s.description = 'Manages tasks by providing interface to crud and search for tasks'
  s.authors = ['Filip Kostovski']
  s.email = 'github.sirfilip@gmail.com'
  s.files = Dir.glob("{lib,bin}/**/*", File::FNM_DOTMATCH).reject {|f| File.directory?(f) }
  s.executables << "ineedto"
  s.homepage = 'https://rubygems.org/gems/ineedto'
  s.license = 'MIT'

  s.add_runtime_dependency 'dry-validation', '1.5.0'
  s.add_runtime_dependency 'sequel', '5.33.0'
  s.add_runtime_dependency 'sqlite3', '1.4.2'
  s.add_runtime_dependency 'terminal-table', '1.8.0'
end
