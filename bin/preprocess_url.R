#requisitos: install.packages("tidyverse")
#este código es auxiliar y convierte la hoja de excel con los estados en una lista única
library(readxl)
library(dplyr)
library(readr)

archivo <- paste0(getwd(),"/data/url_base.xlsx")
destino <- paste0(getwd(),"/data/url_listado.csv")

# lee hojas del archivo
hojas <- excel_sheets(archivo)

#carga cada hoja en un elemento de lista
libro <- list()
i <-1
for (hoja in hojas){
    libro[[i]] <- read_xlsx(archivo, hoja)
    print(nrow(libro[[i]]))
  i <- i+1
}

#concatena las listas
for (i in seq(1,length(libro))){
  if (i==1){
    listado <- libro[[i]]
  }
  else {
    print(nrow(libro[[i]]))
    listado <- bind_rows(listado,libro[[i]])
  }
}

#salva la lista de url's a un csv
write_csv(listado, path = destino)