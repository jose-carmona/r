library(shiny)
library(shinydashboard)
library(ggplot2)
library(scales)
library(dplyr)


ui <- dashboardPage(

  # Título
  dashboardHeader(title = "Mensajes"),

  # Sidebar
  dashboardSidebar(
    sidebarMenu(
      menuItem("Mensajes", tabName = "dashboard", icon = icon("envelope")),
      menuItem("Widgets", tabName = "widgets", icon = icon("th"))
    )
  ),

  # Contenido
  dashboardBody(
    tabItems(
      # Tab del dashboard
      tabItem(tabName = "dashboard",
        verticalLayout(
          fluidRow(
            # Histograma de Eventos
            box( title = "Eventos", width = 10, status = "primary", solidHeader = TRUE, collapsible = TRUE, 
                 plotOutput("plotM", brush = brushOpts(id = "plotM_brush", direction = "x"))),
            # Selector de Fecha y hora
            column( 2,
              dateInput('fecha',
                        label = 'Fecha',
                        value = as.character(Sys.Date()),
                        min = Sys.Date() - 5, max = Sys.Date(),
                        format = "dd/mm/yy",
                        startview = 'month', language = 'es-ES', weekstart = 1
              )
            )
          ),
          fluidRow(
            # Porcentajes de Respuetas Totales
            box( title = "% Total respuesta", width = 5, status = "primary", solidHeader = TRUE, collapsible = TRUE, plotlyOutput("plotT1")),
            # Porentajes de Respuetas en el periodo
            box( title = "% respuesta periodo", width = 5, status = "primary", solidHeader = TRUE, collapsible = TRUE, plotOutput("plotT2"))
          )
        )
      )
    )
  )
)

# Define server logic to display and download selected file ----
server <- function(input, output) {

  # Leemos los Eventos
  eventos <- read.csv("/data/hist_eventos.csv")
  
  # Fecha/Hora de Eventos en POSIX
  eventos <- eventos %>% mutate( fh = as.POSIXct(fh_evento, "%Y-%m-%d %H:%M:%S"))

  # Histograma 
  output$plotM <- renderPlot({
    
    if( !is.null(input$plotM_brush) ) {
      limites <- c(as.POSIXct(input$plotM_brush$xmin, origin = "1970-01-01"), 
                   as.POSIXct(input$plotM_brush$xmax, origin = "1970-01-01"))
    } 
    else {
      limites <- c(as.POSIXct(paste0(input$fecha," 09:00:00"), "%Y-%m-%d %H:%M:%S"), 
                   as.POSIXct(paste0(input$fecha," 21:00:00"), "%Y-%m-%d %H:%M:%S"))
    }
    
    minutos <- as.numeric(difftime(limites[2], limites[1], units="mins"))
    
    ggplot( eventos, aes( x = fh, colour = Evento ) ) +
      geom_freqpoly(bins = minutos) +
      scale_x_datetime(date_minor_breaks = "1 min",
                       labels = date_format("%H:%M"),
                       limits =  limites ) +
      theme_minimal()
  })


}

# Shiny App
shinyApp(ui, server)
