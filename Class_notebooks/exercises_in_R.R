###### EXERCISE 2 (EXTRACT PLAIN TEXT)

# With readr, from the hipotecas_lectura file read only the data from the first semester of
# 2020, and including somehow the names of the columns.

library(readr)

hipotecas_lectura <- read_csv("~/data/hipotecas/hipotecas_lectura", skip=6, n_max=7, col_names = FALSE)
hipotecas_lectura

###### EXERCISE 3 (EXTRACT PLAIN TEXT)

# Try your best reading the original file downloaded from the INE’s site, hipotecas_numero_ine.csv.
# Remark: you may need to specify that the encoding is "ISO-8859-2".

read.table("~/data/hipotecas/hipotecas_numero_ine.csv", encoding = "ISO-8859-2", sep=";", dec=",", header=TRUE, col.names = columnas)

###### EXERCISE 1 (EXTRACT SQL)

# In R, download all the rows from IndexPrice in indexKaggle.sqlite whose region is United
# States or Europe, from 2019 until the end of the period.

library(dplyr)

conn <- DBI::dbConnect(RSQLite::SQLite(), "~/data/indexKaggle.sqlite")

DBI::dbListTables(conn)

Iprice <- tbl(conn, "IndexPrice") %>% 
  collect()

###### EXERCISE 2 (EXTRACT SQL)

# In R and Python, from the indexKaggle.sqlite download a table containing all the close
# prices and volume since 2007 until 2010 whose currency is dollars or euros.

tbl(conn, "IndexMeta")

Iprice_07_10 <- tbl(conn, sql("SELECT * FROM IndexPrice INNER JOIN IndexMeta ON (IndexPrice.stock_index = IndexMeta.stock_index)")) %>% 
  select(date, adj_close, volume, currency) %>% 
  filter(date >= "2007-01-01" & date <"2010-01-01") %>% 
  filter(currency == "USD" | currency == "EUR") %>% 
  collect()

###### EXERCISE 3 (EXTRACT SQL)

# With R or Python, use the elections2016.sqlite database for extracting some data. We
# want a table that includes all the adjusted polls for Trump and Clinton in the Ohio and Pennsylvania states,
# along with the final results, order from the newest poll to the oldest (considering only the enddate column).
# The final table will have the next columns:
#  •(From the Polls table) state, enddate, grade, samplesize, adjpoll_clinton, adjpoll_trump.
#  •(From the Results table) electoral_votes, clinton, trump.

conn_2 <- DBI::dbConnect(RSQLite::SQLite(), "~/data/elections2016.sqlite")

DBI::dbListTables(conn_2)

colnames(tbl(conn_2, "Polls"))
colnames(tbl(conn_2, "Results"))

unique(tbl(conn_2, "Polls"))

tbl(conn_2, sql("SELECT * FROM Polls INNER JOIN Results ON (Polls.State = Results.State)")) %>% 
  filter(state == "Ohio" | state == "Pennsylvania") %>% 
  select(state, enddate, grade, samplesize, adjpoll_clinton, adjpoll_trump, electoral_votes, clinton, trump) %>% 
  arrange(desc(enddate))

###### EXERCISE 4 (EXTRACT SQL) ¿?¿?

# In the Pets database, check if there any owner with more than one pet.

conn_3 <- DBI::dbConnect(RSQLite::SQLite(), "~/data/pets.sqlite")

DBI::dbListTables(conn_3)

tbl(conn_3, "Owners")

tbl(conn_3, "Pets")

tbl(conn_3, sql("SELECT Owners.OwnerID, Pets.Name  FROM Owners LEFT JOIN Pets ON (Owners.OwnerID = Pets.OwnerID)"))
  
###### EXERCISE 5 (EXTRACT SQL)

# Calculate the income per day considering all the procedures.

tbl(conn_3, sql(
  "
  SELECT Date, SUM(Price)
  FROM ProceduresHistory as H INNER JOIN
    ProceduresDetails as D
    ON H.ProcedureType = D.ProcedureType AND
       H.ProcedureSubCode = D.ProcedureSubCode
  GROUP BY Date
  "
))

###### EXERCISE 6 (EXTRACT SQL)

# Using strftime(), calculate the income per month considering only the transactions done by
# owners from the largest city in the database (the largest city is the one with a larger number of owners).

DBI::dbListTables(conn_3)

tbl(conn_3, "ProceduresHistory")

tbl(conn_3, sql(
  "SELECT strftime('%Y-%m',  H.Date) as month, sum(D.Price) as income
  FROM ProceduresHistory as H
  INNER JOIN ProceduresDetails as D
  ON H.ProcedureType = D.ProcedureType AND
  H.ProcedureSubCode = D.ProcedureSubCode
  INNER JOIN Pets as P
  ON H.PetID = P.PetID
  INNER JOIN Owners as O
  ON P.OwnerID = O.OwnerID
  WHERE O.City in (
    SELECT City
    FROM Owners
    GROUP BY City
    ORDER BY COUNT(*) DESC
    LIMIT 1
  )
  GROUP BY strftime('%Y-%m',  H.Date)"
))


###### EXERCISE 1 (TRANSFORM MISSING VALUES)

# Finish replacing the NA in the df_simulated data frame using the column known distributions.
# For column V5 use a normal distribution with a mean and a variance you consider appropriate.

size_pop <- 100

df_simulated <- tibble(
  index = seq_len(size_pop),
  V1 = runif(size_pop),
  V2 = rnorm(size_pop),
  V3 = rnorm(size_pop, 100, 10),
  V4 = rpois(size_pop, lambda = 10)
)


library(purrr)
ups_downs <- runif(size_pop, -0.015, 0.015)
ups_downs[1] <- 20
df_simulated <- df_simulated %>% 
  mutate(V5 = accumulate(ups_downs, ~.x + .x * .y))

head(df_simulated)

# Inventamos datos missing
rows_with_na <- map(1:5, ~sample(1:size_pop, 15))
for(i in seq_along(rows_with_na)){
  df_simulated[[i + 1]][rows_with_na[[i]]] <- NA
}

media <- mean(df_simulated$V5, na.rm=TRUE)
stdv <- sd(df_simulated$V5, na.rm=TRUE)

df_simulated$V5 <- if_else(is.na(df_simulated$V5),
                           rnorm(nrow(df_simulated), media, stdv),
                           df_simulated$V5)

###### EXERCISE 2 (TRANSFORM MISSING VALUES)

# Given the next vector, replace every NA value with the previous non NA value.

library(dplyr)

set.seed(5678)
vector_letters <- sample(letters, 50, TRUE)
vector_letters[sample(seq_len(50), 25)] <- NA

library(zoo)

na.locf(vector_letters,fromLast=FALSE)


###### EXERCISE 3 (TRANSFORM MISSING VALUES)

# Replace all the NA of the column V5 in the df_simulated data frame using the moving average
# method –with a period longer than 1.

moving_average <- function(x,y) {
  if (!is.na(x)) {
    return(x)
  } else {
    prev <- df_simulated$V5[y-1]
    desp <- df_simulated$V5[y-1]
    return(mean(c(prev, desp)))
  }
}

for (x in df_simulated$V5) {
  resultado <- moving_average()
  if (is.na(x)) {
    x <- resultado
  }
}

###### EXERCISE 4 (TRANSFORM MISSING VALUES)

# Build a function for scaling the iris dataset with the min-max approach and scale all the
# numeric columns.

scalling <- function(columna) {
  return((columna - min(columna)) / (max(columna) - min(columna)))
}

iris %>% 
  mutate(across(where(is.numeric), scalling))

###### EXERCISE 5 (TRANSFORM MISSING VALUES)

# For the data frame iris build new columns setosa, versicolor and virginica. setosa will
# equal 1 if Species == "setosa" and 0 elsewhere, and so on.

iris %>% 
  mutate(setosa = if_else(Species == "setosa", 1, 0),
         versicolor = if_else(Species == "versicolor", 1, 0),
         virginica = if_else(Species == "virginica", 1, 0))

###### EXERCISE 1 (TRANSFORM DATES)

# Extract from the Pets database the daily number of procedures from the ProceduresHistory
# table.

conn <- DBI::dbConnect(RSQLite::SQLite(), "~/data/pets.sqlite")

DBI::dbListTables(conn)

tbl(conn, sql("SELECT Date, count(*) FROM ProceduresHistory GROUP BY Date")) 


###### EXERCISE 2 (TRANSFORM DATES)

# In that table you extracted in the previous exercise, create a new column that equals 1 if the date
# is a Sunday; 0, elsewhere. For knowing when a date is Sunday, you can use something like format(a_date,
# format = "%u"), which output the weekday number (7 for Sundays). Remark. The column must be of
# type Date.

tabla <- tbl(conn, sql("SELECT Date, count(*) FROM ProceduresHistory GROUP BY Date")) %>% 
  collect()

tabla <- tabla %>% 
  mutate(sunday = if_else(format(as.Date(Date), format="%u")==7, 1, 0))


###### EXERCISE 3 (TRANSFORM DATES)

# During February 4th 2016 there was a peak, a very extreme value. Create a column with a
# dummy variable indicating that date.

tabla %>% 
  mutate(peak = if_else(as.Date(Date) == "2016-02-4", 1, 0))


###### EXERCISE 4 (TRANSFORM DATES)

# Level variables can be useful when modelling, for indicating whether the average during a
# period was higher than during other period. Create two level variables (1s and 0s), one for each semester.


tabla %>% 
  mutate(semestre = if_else(format(as.Date(Date), format="%m-%d") >= "01-01" & format(as.Date(Date), format="%m-%d") < "06-01", 1, 0))


###### EXERCISE 5 (TRANSFORM DATES) ¿?¿?¿?

# Let’s go now with something independent from the previous data. Imagine we have a data
# frame like the one created from the next code. The first column indicates the beginning and end of each
# week of 2021, but in a terrible format. Create a new column with only the first date of each week, but with
# the format "yyyy-mm-dd".

library(dplyr)

crear_dias <- function(ini, fin) {
  format(seq(as.Date(ini), as.Date(fin), by = 7),
         format = "%d/%m/%Y")
}
fechas_horribles <- paste(
  crear_dias("2020-12-28", "2021-12-27"),
  crear_dias("2021-01-03", "2022-01-02"),
  sep = " - "
)
df <- tibble(
  semana = fechas_horribles,
  metrica = runif(length(fechas_horribles))
)

df %>% 
  mutate(date = as.Date(semana))

as.Date(format(as.Date("28/12/2020 - 03/01/2021"), format="%d-%m-%Y"), format="%Y-%m-%d")


###### EXERCISE 2 (TRANSFORM REGULAR EXPRESSIONS)

# Translate the regex Python operations into R.

library(stringr)

tweet <- "No todo es R, así que estamos pensando en asistir a este meetup sobre Julia, de la mano de @RyanairLabs... o en mandar a @joscani como enviado especial. \
El evento es online, el 2021-09-16, cosa que facilita la asistencia. \
https://meetup.com/es-ES/Travel-Labs-Madrid/events/280438963/ \
#rstatsES #Julia"

str_extract_all(tweet, "@[A-z]+")

str_extract_all(tweet, "[A-z0-9]+")

str_extract_all(tweet, "[A-za-z0-9#]+")

str_extract_all(tweet, "http[A-z0-9:./\\-]+")

str_extract_all(tweet, 'http[A-z0-9:./\\-]+.com')

# ....

###### EXERCISE 1 (LOAD)

# Repeat with R all the process shown in Python for the indexKaggle.sqlite database.

conn <- DBI::dbConnect(RSQLite::SQLite(), '~/data/indexKaggle.sqlite')

query <- " 
  SELECT IndexMeta.region, IndexPrice.stock_index, 
         IndexPrice.date, 
         IndexPrice.adj_close, IndexPrice.volume, 
         IndexMeta.currency
  FROM IndexPrice INNER JOIN IndexMeta
      ON IndexPrice.stock_index = IndexMeta.stock_index
  WHERE IndexMeta.region in ('United States', 'Europe') and 
      IndexPrice.date >= '2019-01-01' and
      IndexPrice.adj_close is not null"

df_sucio <- as.data.frame(tbl(conn, sql(query))) %>% 
  group_by(stock_index) %>% 
  mutate(adj_close = as.numeric(adj_close)) %>% 
  mutate(adj_close = replace_na(adj_close, mean(adj_close)))

indexes <- unique(df_sucio$stock_index)

new_table <- list()

for (i in indexes) {
  df_filtered <- df_sucio %>% 
    select(date, adj_close) %>% 
    filter(stock_index == i) %>% 
    mutate(smoothed = rollmean(adj_close, k = 15, fill = NA))
  
  new_table[[i]] <- df_filtered
}

for (i in indexes) {
  DBI::dbWriteTable(conn, i, new_table[[i]])
}

DBI::dbListTables(conn)


###### EXERCISE 1 (APIS)
