library(readxl)
path_to_file <- "~/data/ejemplos_lectura.xlsx"
df_ejemplos <- read_xlsx(path_to_file)
df_ejemplos

# Hay hojas ocultas
excel_sheets(path_to_file)

# Para leer una hoja en concreto
# Detallo la hoja en concreto que quiero leer.
df_ejemplos <- read_xlsx(path_to_file, sheet = "Fechas")
df_ejemplos

# Quiero leer a partir de la tercera línea. Lo hago mediante skip=2.
# Para leer regiones
df_fechas <- read_xlsx(path_to_file, 
                       sheet = "Fechas", 
                       skip = 2)
df_fechas

# Todavía tiene cosas raras (el df). Ahora le digo que se salte las 3 primeras columnas, pq no me interesan.
# La forma de que no se salte una columna es poner "guess".
df_fechas <- read_xlsx(path_to_file, 
                       sheet = "Fechas", 
                       skip = 2, 
                       col_types = c(rep("skip", 3), rep("guess", 5)))

df_fechas

# Para fechas más complicadas, trabajaremos con dplyr
df_chungo <- read_xlsx(path_to_file, sheet = "Holi")
df_chungo