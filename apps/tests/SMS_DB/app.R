library(shiny)
library(shinydashboard)
library(ggplot2)
library(scales)
library(dplyr)

ui <- dashboardPage(

  # Título
  dashboardHeader(title = "Mensajes"),

  # Sidebar content
  dashboardSidebar(
    sidebarMenu(
      menuItem("Mensajes", tabName = "dashboard", icon = icon("envelope")),
      menuItem("Widgets", tabName = "widgets", icon = icon("th"))
    )
  ),

  # contenido
  dashboardBody(
    tabItems(
      # First tab content
      tabItem(tabName = "dashboard",
        verticalLayout(
          fluidRow(
            box( title = "Eventos", width = 10, status = "primary", solidHeader = TRUE, collapsible = TRUE, plotOutput("plotM")),
            column( 2,
              dateInput('fecha',
                        label = 'Fecha',
                        value = as.character(Sys.Date()),
                        min = Sys.Date() - 5, max = Sys.Date(),
                        format = "dd/mm/yy",
                        startview = 'month', language = 'es-ES', weekstart = 1
              ),
              sliderInput("horas", label = 'Horas', min = 0, max = 24, value = c(9, 21))
            )
          )
        )
      )
    )
  )
)

# Define server logic to display and download selected file ----
server <- function(input, output) {

  eventos <- read.csv("/data/hist_eventos.csv")
  
  eventos <- eventos %>% mutate( fh = as.POSIXct(fh_evento, "%Y-%m-%d %H:%M:%S"))
  
  
  output$plotM <- renderPlot({
    
    limites <- c(as.POSIXct(paste0(input$fecha," ", input$horas[1], ":00:00"), "%Y-%m-%d %H:%M:%S"), 
                 as.POSIXct(paste0(input$fecha," ", input$horas[2], ":00:00"), "%Y-%m-%d %H:%M:%S"))
    
    minutos <- as.numeric(difftime(limites[2], limites[1], units="mins"))
    
    ggplot( eventos, aes( x = fh, colour = Evento ) ) +
      geom_freqpoly(bins = minutos) +
      scale_x_datetime(date_minor_breaks = "1 min",
                       labels = date_format("%H"),
                       limits =  limites ) +
      theme_minimal()
  })


}

# Create Shiny app ----
shinyApp(ui, server)
