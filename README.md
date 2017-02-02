# FreeAgent Utils

Takes Bank statements output in CSV, removes the cruft, and converts into
[FreeAgent compatible
CSV](http://www.freeagent.com/support/kb/banking/file-format-for-bank-upload-csv/).

Currently only compatible with CSV files output from Barclaycard Commercial statements.

## Usage

### Barclaycard

`ruby freeagent_format <input_file> [--output-file <output_file>]`

Uses the CSV output from the 'Monthly Transactions' report inside of your Barclaycard commercial account. This format for this report is as follows:

```
Unit_Name_and_Nbr,
Cardholder_Name,
Merchant,
Merchant_Location,
Account_Number,
MCC,
Date_Occurred,
Date_Posted,
Original_Amount,
Conversion_Rate,
Settlement_Amount,
Allocation,
Transaction_Description
```

This app will output a CSV to the following format:

```
date - dd/mm/yyyy based on date_posted,
amount - inverse of settlement_amount,
description - based on merchant with whitespace removed 
```

## TODO

- Tests! (I wrote this app in a hurry)
- Handle foriegn currency transactions
- Handle multiple input CSVs to multiple files or just to the one file
- More input types
