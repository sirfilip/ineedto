require 'minitest/autorun'
require 'mocha/minitest'
require 'logger'
require 'stringio'
require 'sequel'

require 'cmd'

DB = Sequel.sqlite

DB.create_table(:todos) do
  primary_key :id
  Integer     :priority
  String      :name
  TrueClass   :done
  DateTime    :due_date
  DateTime    :completed_on
end 


describe 'ineedto' do
  before do
    DB[:todos].delete
  end

  describe 'root' do 
  end

  describe 'list' do
  end

  describe 'new' do
  end

  describe 'complete' do
  end

  describe 'completed' do
  end

  describe 'pending' do
  end

  describe 'search' do
  end

  describe 'clean' do
  end
end
