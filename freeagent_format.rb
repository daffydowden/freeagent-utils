#!/usr/bin/ruby
require 'csv'
require 'thor'
require_relative 'lib/barclaycard_row'
require 'pry'

class FreeAgentCSV < Thor

  desc "barclaycard <input_file>", "take a BarclayCard CSV <inptut_file> and output FreeAgent compatible CSV"
  option :output_file
  def barclaycard(input_file)
    output_file = options[:output_file] || 'output.csv' 

    puts "Reading Barclaycard transactions from #{input_file}"

    monthly_transactions = CSV.parse(File.open(input_file))
    monthly_transactions = monthly_transactions[1..monthly_transactions.length].collect{|row| BarclaycardRow.new(row)}

    output_file = File.new(output_file, 'w+')
    monthly_transactions.each do |row|
      output_file.puts row.to_freeagent_csv
    end

    output_file.close
    puts "Finished writing transactions to '#{File.basename output_file}'"
  end
end

FreeAgentCSV.start(ARGV)

