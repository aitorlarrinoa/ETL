library(httr)
# r <- GET("https://servicios.ine.es/wstempus/js/ES/DATOS_SERIE/IPC206446?nult=5")
r <- GET("https://servicios.ine.es/wstempus/js/ES/DATOS_SERIE/IPC206446?date=20210101:20210801")
r

# r es una request a la url de arriba
# r es un informe de que tal ha resultado ser la consulta que yo he hecho a la app.

# información sobre la descarga (nos da un poco igual)
status_code(r)
r$status_code
http_status(r)

headers(r)

# Getting the data ---------------------------------------------------
# el resultado de content() es una lista que nos da información sobre la serie
# y dentro tengo los datos
str(content(r))

datos <- content(r)$Data
class(datos)
length(datos)

library(tidyverse)
# código para convertir una lista sencilla en un data frame
df_datos <- map_dfr(datos, function(x){
  tibble(
    year = x$Anyo, 
    month = x$FK_Periodo, 
    value = x$Valor
  )
})

df_datos %>% 
  mutate(date = paste0(year, "-", month, "-01"), 
         date = as.Date(date)) %>% 
  ggplot() + 
  geom_line(aes(x = date, y = value)) + 
  labs(title = "IPC - Año 2021", x = "", y = "IPC") + 
  theme(panel.background = element_blank())

