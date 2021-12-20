
library(dplyr)

# para que dplyr sepa trabajar con bases de datos, se usa el paquete(dbplyr). Simplemente se debe tener descargada,
# no hace falta cargarla


#DBI es un paquete que sirve para leer los datos. Lo prmero que recibe es un objeto que viene dado por un paquete que
# indica qué tipo de conexión realizamos. En este caso RSQLite.
# también debemos introducir qué froma leemos el fichero. En este caso lo leemos en memoria
conn <- DBI::dbConnect(RSQLite::SQLite(), "/home/rstudio/data/airbnb.sqlite")

#copy_to(conn, airbnb)
DBI::dbListTables(conn)

# Ejercicio 1

# Descarga la tabla listings en un data frame de pandas o de R. Con SQL, haz un join con la tabla hoods para añadir el dato de 
# distrito (neighbourhood_group) y asegúrate de que extraes esta columna en el data frame en lugar de neighbourhood.

listings <- tbl(conn, sql("SELECT * FROM listings")) 
head(listings)
colnames(listings)

hoods <- tbl(conn, sql("SELECT * FROM hoods")) %>% collect()
head(hoods)
colnames(hoods)

# hacemos el join

unique(listings$neighbourhood_cleansed)
unique(hoods$neighbourhood_group)
unique(hoods$neighbourhood)

listings_joined <- tbl(conn, sql("SELECT L.id, H.neighbourhood_group, L.review_scores_rating, L.number_of_reviews, L.price, L.room_type
                                 FROM listings AS L 
                                 INNER JOIN hoods AS H ON (L.neighbourhood_cleansed = H.neighbourhood)")) %>% 
  collect()
colnames(listings_joined)

# Ejercicio 2

# a)

reviews <- tbl(conn, sql("SELECT * FROM reviews"))
colnames(reviews)

reviews_new <- tbl(conn, sql("SELECT strftime('%Y-%m', R.date) AS Mes, H.neighbourhood_group, L.number_of_reviews 
                           FROM hoods AS H
                           INNER JOIN listings as L ON (L.neighbourhood_cleansed = H.neighbourhood)
                           INNER JOIN reviews as R ON (L.id = R.listing_id)
                           WHERE Mes > 2011 GROUP BY H.neighbourhood_group, strftime('%Y-%m', R.date)")) %>% collect()

## TRANSFORMACIÓN

# price, number_of_reviews, review_scores_rating

# Ejercicio 3

library(stringr)

colnames(listings)
listings_2 <- listings_joined %>% 
  collect() %>% 
  mutate(price = gsub("\\,", "", price))

listings_2 <- listings_2 %>% 
  mutate(price = as.numeric(str_extract(price, "[0-9]+\\.[0-9]+")))

listings_2 %>% 
  select(price)



# Ejercicio 4

listings_2 %>% 
  select(number_of_reviews, review_scores_rating, room_type)

unique(listings_2$room_type)

for (i in 1:nrow(listings_2)) {
  if (is.na(listings_2$number_of_reviews[i])) {
    listings_new <- listings_2 %>% 
      filter(room_type == listings_2$room_type[i])
    listings_2$number_of_reviews[i] <- sample(na.omit(listings_new$number_of_reviews), 1)
  }
} 

for (i in 1:nrow(listings_2)) {
  if (is.na(listings_2$review_scores_rating[i])) {
    listings_new <- listings_2 %>% 
      filter(room_type == listings_2$room_type[i])
    listings_2$review_scores_rating[i] <- sample(na.omit(listings_new$review_scores_rating), 1)
  }
} 


# Ejercicio 5

# Con los missing imputados y el precio en formato numérico ya puedes
# agregar los datos. A nivel de distrito y de tipo de alojamiento, hay que calcular:

colnames(listings_2)

unique(listings_2$neighbourhood_group)

# falta lo del id !!!!!!!!!!

summary <- listings_2 %>% 
  group_by(neighbourhood_group, room_type) %>% 
  summarise(nota = weighted.mean(review_scores_rating, number_of_reviews),
            precio = mean(price)) 


# Ejercicio 6

tail(reviews_joined)
`strftime('%Y-%m', R.date)` <- c()
neighbourhood_group <- c()
number_of_reviews <- c()
a=1
for (i in 1:nrow(reviews_joined)) {
  if (reviews_joined$`strftime('%Y-%m', R.date)`[i] == "2021-07"){
    `strftime('%Y-%m', R.date)`[a] <- "2021-08" 
    neighbourhood_group[a] <- reviews_joined$neighbourhood_group[i]
    number_of_reviews[a] <- reviews_joined$number_of_reviews[i]
    a = a + 1
  }
} 

new_df <- cbind(`strftime('%Y-%m', R.date)`, neighbourhood_group, number_of_reviews)

df_prediction <- rbind(reviews_joined, new_df, make.row.names=TRUE)
tail(df_prediction)

# falta ordenar el df!!

# Ejercicio 7

reviews_joined

unique(reviews_joined$`strftime('%Y-%m', R.date)`) %>% 
  arrange()

library(stringr)

secuencia <- seq(as.Date("2011-01-01"), as.Date("2021-07-01"), by="months") 
secuencia_new <- c()
s <- 1
for (i in 1:length(secuencia)) {
  secuencia_new[s] <- str_extract(secuencia[i], "[0-9]{4}\\-[0-9]{2}")
  s = s +1
}
secuencia_new
neighbourhood_group <- unique(reviews_joined$neighbourhood_group)


library(tidyr)
all_possibilities <- crossing(neighbourhood_group, secuencia_new)
as.data.frame(all_possibilities)
colnames(all_possibilities) <- c("neighbourhood_group", "strftime('%Y-%m', R.date)")
assss <- as.data.frame(full_join(all_possibilities, reviews_joined, by=c("neighbourhood_group", "strftime('%Y-%m', R.date)")))

for (i in 1:nrow(assss)) {
  if (is.na(assss$number_of_reviews[i])) {
    assss$number_of_reviews[i] <- 0
  }
}


### Ejercicio 8

#Sube a la base de datos las dos tablas que has creado. No sobreescibas las que hay: crea dos
#tablas nuevas. Haz una prueba de que todo está en orden, haciendo SELECT * FROM nombre_tabla
#LIMIT 10 para cada tabla. Si la fecha tiene un formato raro, es posible que necesites definirla en el
#data frame como tipo texto.

assss
reviews_joined

new_table <- list(assss, reviews_joined)
names <- c("filtrado1", "filtrado2")
for (i in 1:2) {
  DBI::dbWriteTable(conn, names[i], new_table[[i]])
}

DBI::dbListTables(conn)
