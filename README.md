# r
Docker image for R

### Paquetes instalados

* shiny
* rmarkup
* ggplot2
* shinydashboard

Falta por instalar
* googlesheets

### Ejecutar

Para ejecutar:

´´´
docker run --rm -p 3838:3838 -v  "$PWD"/apps/:/srv/shiny-server/ -v "$PWD"/logs/:/var/log/shiny-server/ -v "$PWD"/data/:/data --name shiny josecarmona/r
´´´
