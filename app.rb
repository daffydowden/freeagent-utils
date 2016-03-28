#!/usr/bin/ruby
require 'csv'
require 'pry'
require_relative 'lib/barclaycard_row'

monthly_transactions = CSV.parse(File.open("./Monthly\ Transactions\ -\ 12-2015.txt"))
monthly_transactions = monthly_transactions[1..monthly_transactions.length].collect{|row| BarclaycardRow.new(row)}

output_file = File.new('output.csv', 'w+')
monthly_transactions.each do |row|
  output_file.puts row.to_freeagent_csv
end

output_file.close

