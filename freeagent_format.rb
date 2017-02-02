#!/usr/bin/ruby
require 'csv'
require 'thor'
require_relative 'lib/barclaycard_row'
require 'pry'

require 'tty-prompt'
require 'tty-table'

class FreeAgentCSV < Thor


  desc "barclaycard", "take a BarclayCard CSV and output FreeAgent compatible CSV"
  option :input_file
  option :output_file
  def barclaycard()
    prompt = TTY::Prompt.new

    # Input file
    if (!input_file = options[:input_file]) 
      csv_files = Dir.glob("*.csv")
      input_file = prompt.select("Which CSV file contains your Barclaycard transactions?", csv_files)
    end
    puts "Using #{input_file}" 
    
    # Output file
    if (!output_file = options[:output_file]) 
      output_file = prompt.ask('Where would you like the output written?', default: 'output.csv')
    end
    puts "Writing to #{output_file}"


    # The MEAT
    puts "Reading Barclaycard transactions from #{input_file}"

    monthly_transactions = CSV.parse(File.open(input_file))
    monthly_transactions = monthly_transactions[1..monthly_transactions.length].collect{|row| BarclaycardRow.new(row)}

    table = TTY::Table.new header: BarclaycardRow.headers

    output_file = File.new(output_file, 'w+')
    monthly_transactions.each do |row|
      output_file.puts row.to_freeagent_csv_row
      table << row.to_freeagent_csv_row.split(',')
    end

    output_file.close
    puts "Finished writing transactions to '#{File.basename output_file}'"

    puts table.render :unicode, alignments: [:left, :right, :left]
  end
end

FreeAgentCSV.start(ARGV)
