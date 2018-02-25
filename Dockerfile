FROM rocker/tidyverse

MAINTAINER Jose Carmona

RUN R -e "install.packages(c('shinydashboard'), repos='https://cran.rstudio.com/')"

EXPOSE 3838
