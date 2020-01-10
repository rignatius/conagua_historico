#requisitos: install.packages("tidyverse")
#este código intenta leer los archivos de una dirección listada en un archivo de URL's y los descarga a una carpeta
#para trabajarlos localmente
library(RCurl)
library(readr)
library(stringr)

archivo <- paste0(getwd(),"/data/url_listado.csv")
listado <- read_csv(archivo)
existentes <- dir(paste0(getwd(),"/data/descargas"))

for (i in seq(1,nrow(listado)) ){
  #extrae con regex el id de la estación, que es un número de 4 o más dígitos juntos
  id_estacion <- str_extract(listado[i,], "\\d{4,}")
  #si el archivo no está descargado, y si no está, procee a la 
  if (!is.element(paste0(id_estacion,".txt"),existentes)){
    print(paste("Descargando archivo",listado[i,]))
    miarchivo <- getURL(listado[i,])
    write(file=paste0(getwd(),"/data/descargas/",id_estacion,".txt"), miarchivo)
  }
}
#, ssl.verifyhost=FALSE, ssl.verifypeer=FALSE)

# 
# mydat <- read.csv(textConnection(miarchivo), header=T)
# head(mydat,20)
# 
# getURL("https://smn.conagua.gob.mx/tools/RESOURCES/Diarios/14040x.txt")

