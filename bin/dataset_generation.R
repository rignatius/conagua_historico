library(readr)
library(stringr)
library(tidyr)
library(magrittr)

# archivos descargados existentes en el directorio
existentes <- dir(paste0(getwd(),"/data/buffer/estaciones"))

# Leemos los archivos que están en el drectorio
# uno por uno los escribimos en el archivo buffer
# Primero el catálogo de estaciones

n_archivos <- length(existentes)
for (i in seq(1, n_archivos )){ #length(existentes)
  if (i==1){ #guarda con encabezados como .csv con la funcion write_csv
    buffer <- read_csv(file = paste0(getwd(),"/data/buffer/estaciones/",existentes[i]),
                       col_types = list(col_character(),col_character())) %>%
      pivot_wider(., names_from = "X1", values_from = "X2")
    write_csv(buffer, path = paste0(getwd(),"/data/output/cat_estaciones.csv"))
    fileConn <- file(paste0(getwd(),"/data/output/cat_estaciones.csv"), open = "a") #se abre en modo appending
    #una sola vez para ser muy eficientes en la escritura, y se deja abierta para escribir en las
    #iteraciones subsecuentes
  }
  else{ #solo hace append sin encabezados
    buffer <- read_csv(file = paste0(getwd(),"/data/buffer/estaciones/",existentes[i]),
                       col_types = list(col_character(),col_character())) %>%
      pivot_wider(., names_from = "X1", values_from = "X2") %>%
      as.character(.) %>%
      gsub(",","", . ) %>%
      paste( . ,collapse = ",")
    writeLines(buffer, con =fileConn, sep= "\n")
    print(paste(i,"de",n_archivos))
    rm(buffer)
  }
}
close(fileConn)



#ahora los datasets
existentes <- dir(paste0(getwd(),"/data/buffer/mediciones"))
n_archivos <- length(existentes)
for (i in seq(1, n_archivos )){ #length(existentes)
  if (i==1){ #guarda con encabezados como .csv con la funcion write_csv
    buffer <- read_csv(file = paste0(getwd(),"/data/buffer/mediciones/",existentes[i]),
                       col_types = list(col_character(),col_character(),col_character(),col_character(),col_character()))
    buffer$id_estacion <- str_extract(existentes[i], "\\d{4,}")
    write_csv(buffer, path = paste0(getwd(),"/data/output/conagua_hist_t_p.csv"))
    fileConn <- file(paste0(getwd(),"/data/output/conagua_hist_t_p.csv"), open = "a") #se abre en modo appending
    #una sola vez para ser muy eficientes en la escritura, y se deja abierta para escribir en las
    #iteraciones subsecuentes
    rm(buffer)
  }
  else{ #solo hace append sin encabezados
    buffer <- read_csv(file = paste0(getwd(),"/data/buffer/mediciones/",existentes[i]),
                       col_types = list(col_character(),col_character(),col_character(),col_character(),col_character()))
    buffer$id_estacion <- str_extract(existentes[i], "\\d{4,}")
    buffer <- format_csv(buffer, na = "NA", col_names = FALSE,quote_escape = "double")
    writeLines(buffer, con =fileConn, sep= "\n") 
    print(paste(i,"de",n_archivos))
    rm(buffer)
  }
}
close(fileConn)
