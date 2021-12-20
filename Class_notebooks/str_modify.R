library(stringr)
library(fivethirtyeight)
library(dplyr)


# quiero saber qué casos contienen la letra "e"
x <- c("apple", "banana", "pear")

# La función str_detect() primero recibie dónde estamos buscando la información.
# Esto en general es un vector
str_detect(x, "e")
# me devuelve True y False en función si la letra está en una posición i

# subset me devuelve los elementos de x que cumplen una condición dada. En esta ocasión,
# la condición es que contenga la letra e
str_subset(x, "e")

# which te devuelve las posiciones en las que hay una e en x
str_which(x, "e")


# con las funciones str_ hay que tener cuidado con las mayúsculas y minúsculas, pues estas funciones
# son sensibles a mayus y minus

# por ej:
apples <- c("apple", "Apple", "APPLE")
str_detect(apples, "apple")


# para eso hacemos lo siguiente:
# usamos la función tolower para pasar todo a minúsuculas
str_detect(tolower(apples), "apple")


# paquete ficethirtyeight es un paquete que tiene bases de datos
# veamos una
head(fivethirtyeight::biopics)


fivethirtyeight::biopics %>% 
  select(lead_actor_actress) 

# paso1: vamos a ver qué nombres contienen la letra w:
# paso2: vamos a construir una columna más en la que nos quedamos solo con el nombre

# paso 1
fivethirtyeight::biopics %>% 
  select(lead_actor_actress) %>% 
  mutate(contiene_w = str_detect(lead_actor_actress, "w"))

# paso 2
# str_extract() extrae de los elementos de x, un patrón. El patrón que se cumple en todos los
# nombres de pila que buscamos. Entendemos con nombre de pila como conunto de letras de la a a la z
# incluidas mayus y minus, sin espacios.
fivethirtyeight::biopics %>% 
  select(lead_actor_actress) %>% 
  mutate(contiene_w = str_extract(lead_actor_actress, 
                                 "[A-z]"))

# esto me trae la primera letra, pero quiero que me traiga todas, hasta el espacio.

fivethirtyeight::biopics %>% 
  select(lead_actor_actress) %>% 
  mutate(nombre_pila = str_extract(lead_actor_actress, 
                                  "[A-z]+"))

# el más nos sirve para que busque y busque letras hasta que se encuentre con algo que no está en el
# conjunto [A-z]

# Vamos a intentar ahora que coja los guiones también

fivethirtyeight::biopics %>% 
  select(lead_actor_actress) %>% 
  mutate(nombre_pila = str_extract(lead_actor_actress, 
                                  "[A-z\\-]+"))


# el guión de A-z significa: vale todo desde A hasta la z. Es equivalente a poner ABCDEFGHIJK....abcdefg....z
# si le pongo \\ me recoge literal lo que quiera decir después. Es decir, si pongo \\-, le esto diciendo:
# interpreta el guión literalmente. \\ es una expresión regular!!

# si ahora quiero coger los apellidos:
# cómo se pone "el final" mediante expresión regular: con un dólar

fivethirtyeight::biopics %>% 
  select(lead_actor_actress) %>% 
  mutate(nombre_pila = str_extract(lead_actor_actress, 
                                  "[A-z\\-]+$"))

str_extract("Su DNI es 02700442C", "[0-9]+[A-Z]+$")

texto <- "8YPFLMRXKY27I3JI6VGO25470362IY1T9LYOF8"

gsub("[0-9]+[A-Z]", " " , texto)

# Vamos a transformar ...

# str_replace() recibe lo que queremos cambiar, despu´s el partón y luego con qué queremos
# cambiar.

# quiero reemplazar los espacios en blanco con barras bajas

fivethirtyeight::biopics %>% 
  select(lead_actor_actress) %>% 
  mutate(nombre_transformado = str_replace(tolower(lead_actor_actress), "\\s", "_"))
  
#\s sería una expresión egular, pero "_" no.
  
fivethirtyeight::biopics %>% 
  select(lead_actor_actress) %>% 
  filter(str_detect(lead_actor_actress, "Bichir"))

  
  
