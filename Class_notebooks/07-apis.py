import requests
r = requests.get('https://servicios.ine.es/wstempus/js/ES/DATOS_SERIE/IPC206446?date=20210101:20210801')
r.status_code

import pprint
# librería para visualizar mejor los diccionarios json
pprint.pprint(r.json())

type(r.json())
r.json().keys()

# el diccionario r.jsn() tiene un elemento que se llama data. Data a su vez es un diccionario
type(r.json()['Data'])
type(r.json()['Data'][0])
r.json()['Data'][0] # yo lo que quiero es que esta linea sea un registro de la tabla


import pandas as pd
# map recibe una función y un objeto
# map nos aplica la función lambda x: (x['Anyo'], x['FK_Periodo'], x['Valor']) a todos los elementos
# de r.json()['Data']
reduced_data = map(lambda x: (x['Anyo'], x['FK_Periodo'], x['Valor']), r.json()['Data'])
df_ipc=pd.DataFrame(reduced_data, columns=['year', 'month', 'value'])
df_ipc.head()

# YahooFinancials -----------------------------------------------

from yahoofinancials import YahooFinancials
from datetime import date

yf = YahooFinancials('TSLA')
data = yf.get_historical_price_data(
  start_date='2020-01-01',
  end_date=date.today().strftime('%Y-%m-%d'), 
  time_interval='daily'
) 
 
df = pd.DataFrame(data['TSLA']['prices'])
df.head()
