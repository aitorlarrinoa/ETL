###### EXERCISE 1 (EXTRACT PLAIN TEXT)
# With pandas, from the hipotecas_lectura file read only the data from the second semester
# of 2020, and including somehow the names of the columns.

import pandas as pd

pd.read_csv("~/data/hipotecas/hipotecas_lectura", skiprows=[1,2,3,4,5,6], nrows=7, header=0, delimiter=",")

###### EXERCISE 1 (EXTRACT EXCEL)

# Read with Python and pandas the second sheet of the ejemplos_lecturas.xlsx file.

pd.read_excel("~/data/ejemplos_lectura.xlsx", sheet_name=1)


###### EXERCISE 1 (APIS)

# Select three subgroups within the INE data base and retrieve the IPC for these subgroups.
# Make the request within a loop. Somehow, manage to get a table similar to the original one. It can be done
# in Python or R.




###### EXERCISE 2 (APIS)

# Think on a company you’re interested in and extract the following data. Check the documen-
# tation.

from yahoofinancials import YahooFinancials
from datetime import date

yf = YahooFinancials('AAPL')
yf

# get the market cap
market_cap = yf.get_market_cap() 

market_cap
 
# its PE ratio.
pe_ratio = yf.get_pe_ratio()
pe_ratio

# ts total revenue
total_revenue = yf.get_total_revenue()
total_revenue
