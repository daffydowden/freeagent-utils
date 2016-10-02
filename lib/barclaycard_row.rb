require 'date'

class BarclaycardRow
  #attr_reader   :amount

  attr_writer   :transaction_date,
                :posted_date

  attr_accessor :cardholder_name,
                :account_number,
                :merchant_name,
                :currency,
                :original_amount,
                :original_currency,
                :conversion_rate,
                :transaction_time,
                :authorisation_code,
                :transaction_id,
                :MCC,
                :MCC_description,
                :merchant_category,
                :merchant_towncity,
                :merchant_countystate,
                :merchant_postcodezipcode,
                :transaction_type,
                :amount,
                :statement_cycle

  def initialize(row)
    @cardholder_name = row[0] 
    @merchant_name = row[3] 
    @account_number = row[1] 
    @mcc = row[13] 
    @date_occurred = DateTime.parse(row[2], "%d.%m.%Y")
    @date_posted = DateTime.parse(row[9],  "%d.%m.%Y")
    self.settlement_amount = row[4]
    #@conversion_rate = row[8]

    #self.settlement_amount = row[10]
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
    @merchant_name.strip
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

  def to_freeagent_csv
    #date - dd/mm/yyyy,Amount - 2dp,Description
    "#{date_posted},#{output_amount},#{description}"
  end
end
