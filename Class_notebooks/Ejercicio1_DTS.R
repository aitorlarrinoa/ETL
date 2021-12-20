# Ejercicios 1 y 2 Dates and Time Series

# Ejercicio 1

library(dplyr)
conn <- DBI::dbConnect(RSQLite::SQLite(), "/home/rstudio/data/pets.sqlite")

tbl(conn, sql("SELECT * FROM ProceduresHistory")) %>% 
  group_by(Date) %>% 
  summarise(daily_proced = sum(ProcedureSubCode))
  
# Ejercicio 2

