# install.packages("dbplyr")
library(dplyr)

# para que dplyr sepa trabajar con bases de datos, se usa el paquete(dbplyr). Simplemente se debe tener descargada,
# no hace falta cargarla

# Creamos una base de datos en memoria.
#DBI es un paquete que sirve para leer los datos. Lo prmero que recibe es un objeto que viene dado por un paquete que
# indica qué tipo de conexión realizamos. En este caso RSQLite.
# también debemos introducir qué froma leemos el fichero. En este caso lo leemos en memoria
conn <- DBI::dbConnect(RSQLite::SQLite(), ":memory:")

# Con dplyr podemos subir una tabla a la base de datos. 
# En este caso, nuestra tabla en un dataframe predefinido en R.
# conn es la conexión a la base de datos. Como engine en python
copy_to(conn, mtcars)
DBI::dbListTables(conn)

#tbl(conn,data) nos da acceso a la base de datos mediante la conexión conn.
# Al cargarlo, no se ven las filas que hay. Nos sale que la dimensión es ??x11.
# Lo que hace es descargarse 10 filas como medida de precaución.

# Evaluación perezosa

# La evaluación que se hace a continuación se hace en la base de datos y se evita cargarlo en memoría.
# ESTO ES MUY BUENO!!

summary <- tbl(conn, "mtcars") %>% 
  group_by(cyl) %>% 
  summarise(mpg = mean(mpg, na.rm = TRUE)) %>% 
  arrange(desc(mpg))

# summary

summary %>% show_query()

# execute query and retrieve results
# con la función collect nos traemos la base de datos entera a memoria. collect() tarda mucho!!
summary %>% collect()

own_query <- tbl(conn, sql("SELECT * FROM mtcars LIMIT 20"))
own_query


#dplyr funciona muy mal con joins. No es recomendable.
