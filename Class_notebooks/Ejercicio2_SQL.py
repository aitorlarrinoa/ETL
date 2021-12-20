
# Vamos a conectarnos a la base de datos
from sqlalchemy import create_engine
# para poder cargar la base de datos, hacemos create_engine. 
engine = create_engine('sqlite:///data/indexKaggle.sqlite')

import pandas as pd



