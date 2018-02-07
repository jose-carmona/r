FROM rocker/shiny

MAINTAINER Jose Carmona

RUN R -e "install.packages(c('ggplot2','shinydashboard'), repos='https://cran.rstudio.com/')" 

EXPOSE 3838
