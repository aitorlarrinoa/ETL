# Conectamos a la base de datos
from sqlalchemy import create_engine
engine = create_engine('sqlite:///data/indexKaggle.sqlite')

# Trabajaremos con pandas
import pandas as pd

# for downloading the entire table (es muy raro tener que descargarse una tabla entera)
# pd.read_sql('IndexMeta', engine)

# Cargamos en un DataFrame el resultado de una query SQL
an_entire_table = pd.read_sql('SELECT * FROM IndexMeta', engine)
an_entire_table.head()

# Exploración de tablas
from sqlalchemy import inspect
# con la función inspect, vemos las tablas que hay
inspector = inspect(engine)
print(inspector.get_table_names())

inspector.get_columns('IndexPrice')

# Para limitar el número de filas
limited_prices = pd.read_sql('SELECT * FROM IndexPrice LIMIT 10', engine)
print(limited_prices)

limited_prices.close

# para saber qué activos tenemos
pd.read_sql("select distinct stock_index from IndexPrice", engine)


# Para queries más complejas:
# 
# - The evolution of the indexes from United States and Europe. 
#   This region information is available in the `IndexMeta` table, 
#   so we'll need a `JOIN` sentence. 
# - We will download the price at the close and the volume, daily. 
# - From 2019 and so forth. 
# - We are also downloading the currency.


query = """
  SELECT IndexMeta.region, IndexPrice.stock_index, 
         IndexPrice.date, 
         IndexPrice.adj_close, IndexPrice.volume, 
         IndexMeta.currency
  FROM IndexPrice INNER JOIN IndexMeta
      ON IndexPrice.stock_index = IndexMeta.stock_index
  WHERE IndexMeta.region in ('United States', 'Europe') and 
      IndexPrice.date >= '2019-01-01'
"""

df_usa_eu_prices = pd.read_sql(query, engine)
df_usa_eu_prices.head()


df_usa_eu_prices.describe()



####################

from sqlalchemy import create_engine

engine = create_engine("sqlite:///data/indexKaggle.sqlite")


import pandas as pd

an_entire_table = pd.read_sql("SELECT * FROM IndexMeta", engine)
an_entire_table.head()

from sqlalchemy import inspect

inspector = inspect(engine)
inspector.get_table_names()


an_entire_table = pd.read_sql("SELECT * FROM IndexMeta LIMIT 10", engine)
an_entire_table.head()

