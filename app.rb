#!/usr/bin/ruby
require 'csv'
require 'date'
require 'pry'

class BarclaycardRow
  attr_reader   :merchant_location,
                :original_amount
  attr_writer   :date_occurred,
                :date_posted
  attr_accessor :unit_name_and_nbr,
                :cardholder_name,
                :merchant,
                :account_number,
                :mcc,
                :conversion_rate,
                :allocation,
                :transaction_description

  def initialize(row)
    @unit_name_and_nbr = row[0]
    @cardholder_name = row[1] 
    @merchant = row[2] 
    self.merchant_location = row[3] 
    @account_number = row[4] 
    @mcc = row[5] 
    @date_occurred = Date.strptime(row[6], "%m/%d/%Y")
    @date_posted = Date.strptime(row[7],  "%m/%d/%Y")
    self.original_amount = row[8]
    @conversion_rate = row[9]
    self.settlement_amount = row[10]
    @allocation = row[11].to_s
    @transaction_description = row[12].to_s
  end 

  def date_occurred
    @date_occurred.strftime('%d/%m/%Y')
  end

  def date_posted
    @date_posted.strftime('%d/%m/%Y')
  end

  def settlement_amount
    @settlement_amount[:pounds] + '.' + (@settlement_amount[:pence].to_i / 100).to_s.rjust(2,'0')
  end

  def output_amount
    if settlement_amount.start_with?('-')
      settlement_amount.gsub('-','')
    else
      '-' + settlement_amount
    end
  end

  def description
    @merchant.strip
  end

  def original_amount=(amt)
    @original_amount = /(?<pounds>\-?\d+)\.(?<pence>\d+)/.match(amt)
  end

  def settlement_amount=(amt)
    @settlement_amount = /(?<pounds>\-?\d+)\.(?<pence>\d+)/.match(amt)
  end
  
  def merchant_location=(value)
    if value =~ /^K YOU/
      @merchant += value
      @merchant_location = ""
    else
      @merchant_location = value
    end
  end

  def to_s
    output = []
    output << "Unit_Name_and_Nbr: " + (@unit_name_and_nbr || "")
    output << "\nCardholder_Name: " + (@cardholder_name  || "")
    output << "\nMerchant: " + (@merchant  || "")
    output << "\nMerchant_Location: " + (@merchant_location  || "")
    output << "\nAccount_Number: " + (@account_number  || "")
    output << "\nMCC: " + (@mcc  || "")
    output << "\nDate_Occurred: " + (@date_occurred  || "")
    output << "\nDate_Posted: " + (@date_posted  || "")
    output << "\nOriginal_Amount: " + (@original_amount  || "")
    output << "\nConversion_Rate: " + (@conversion_rate  || "")
    output << "\nSettlement_Amount: " + (@settlement_amount || "")
    output << "\nAllocation: " + (@allocation || "")
    output << "\nTransaction_Description: " + (@transaction_description || "")
    return output.to_s
  end
end

monthly_transactions = CSV.parse(File.open("./Monthly\ Transactions\ -\ 12-2015.txt"))
monthly_transactions = monthly_transactions[1..monthly_transactions.length].collect{|row| BarclaycardRow.new(row)}


output_file = File.new('output.csv', 'w+')

#binding.pry 

monthly_transactions.each do |row|
  #Format
  #DATE - dd/mm/yyyy,Amount - 2dp,Description
  output_file.puts "#{row.date_posted},#{row.output_amount},#{row.description}"
end

output_file.close

