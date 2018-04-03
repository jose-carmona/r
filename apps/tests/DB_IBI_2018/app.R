library(shiny)
library(shinydashboard)

#' definición de la página
ui <- dashboardPage(

  # Título
  dashboardHeader(title = "IBI 2018"),

  # Sidebar
  dashboardSidebar(
    sidebarMenu(
      menuItem("Resumen", tabName = "resumen", icon = icon("tachometer")),
      menuItem("Mensajes", tabName = "mensajes", icon = icon("envelope"))
    )
  ),

  # Contenido
  dashboardBody(
    tabItems(
      # Tab de resumen
      tabItem(tabName = "resumen",
        verticalLayout(
          fluidRow(
            # % Mensajes abiertos
            valueBoxOutput("msgAbiertosBox"),
            # % Mensajes que han terminado en pago por pasarela
            valueBoxOutput("msgPagoBox"),
            # % Mensajes que han descargado documento
            valueBoxOutput("msgDescargasBox")
          )
        )
      ),
      
      # Tab de mensajes
      tabItem(tabName = "mensajes",
        verticalLayout(
          fluidRow(
            valueBoxOutput("msgTESTBox")
             )
          )
        )
      )
    )
  )

server <- function(input, output) {
  
  # Mensajes abiertos
  output$msgAbiertosBox <- renderValueBox({
    valueBox("99%", "Abiertos", icon = icon("envelope-open"), color = "yellow")
  })

  # Mensajes que han terminado en pago por pasarela de pago
  output$msgPagoBox <- renderValueBox({
    valueBox("99%", "Pago", icon = icon("credit-card"), color = "yellow")
  })
  
  # Mensajes que han terminado en pago por pasarela de pago
  output$msgDescargasBox <- renderValueBox({
    valueBox("99%", "Descargas", icon = icon("file"), color = "yellow")
  })
  
  output$msgTESTBox <- renderValueBox({
    valueBox("80%", "Approval", icon = icon("envelope") ,color = "blue")
  })
}

# Shiny App
shinyApp(ui, server)
