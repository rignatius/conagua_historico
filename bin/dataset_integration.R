library(readr)
library(stringr)
library(tidyr)
library(magrittr)
library(lubridate)

datos <- read(file = "C:/Users/r.de.castro.garcia/OneDrive - Accenture/cookbook/conagua_historico/data/descargas/1001.txt")
LINEAS_ENCABEZADO <- c(4,20)

archivo <-  "C:/Users/r.de.castro.garcia/OneDrive - Accenture/cookbook/conagua_historico/data/descargas/1001.txt"

# Lee el encabezado
encabezado <- read_delim(read_lines(file = archivo,
                                    skip = LINEAS_ENCABEZADO[1],
                                    skip_empty_rows = TRUE,
                                    n_max = 12)
                         ,delim=":"
                         ,col_names = FALSE)
# Limpia el encabezado de espacios y caracteres sucios
encabezado$X1 <- str_replace(encabezado$X1,"<d3>","O")
encabezado$X2 <- str_replace(encabezado$X2,"<U\\+00B0>","")
encabezado$X2 <- str_replace(encabezado$X2," msnm","")
encabezado$X1 <- str_trim(encabezado$X1)
encabezado$X2 <- str_trim(encabezado$X2)
# traspone el encabezado a formato de registro
pivot_wider(encabezado, names_from = X1, values_from = X2)

# lee el cuerpo del archivo
cuerpo <- read_lines(file = archivo,
                     skip = LINEAS_ENCABEZADO[2],
                     skip_empty_rows = TRUE) %>% #lee el archivo
  str_replace_all(.,"\\s{1,}"," ") %>% #remueve espacios en blanco múltiples
  str_trim(.) %>% #remueve los espacios en blanco iniciales/finales
  head(.,-2) %>% #remueve la cola
  read_delim(.,
             delim = " ",
             na = c("Nulo"),
             col_names = c("FECHA","PRECIP","EVAP","TMAX","TMIN"),
             col_types = list(col_character(), col_double(), col_double(), col_double(), col_double()))

# convierte la cadena fecha en un tipo fecha
cuerpo$FECHA <- dmy(cuerpo$FECHA)