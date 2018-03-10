# r
Docker image for R. Tenemos 2 imágenes:

* tidyverse: derivada de rocker/tidyverse:latest. rstudio + shiny + todos los paquetes necesarios para trabajar
* shiny: derivada de rocker/shiny:latest. shiny + shinydashboard + todos los paquetes necesarios para ejecución

### Paquetes instalados

* tidyverse
* jsonlite
* shinydashboard

Falta por instalar
* googlesheets
* roracle
  - oracle client

### Ejecutar

Para ejecutar:

´´´
docker run -d -p 3838:3838 -p 8787:8787 -v "$PWD"/apps/:/srv/shiny-server/ -v "$PWD"/logs/:/var/log/shiny-server/ -v "$PWD"/data/:/data  -e ADD=shiny --name tidyverse josecarmona/tidyverse

´´´
