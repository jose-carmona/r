library(shiny)
library(shinydashboard)
library(ggplot2)
library("jsonlite")
library("RCurl")

ui <- dashboardPage(

  # Título
  dashboardHeader(title = "Investigaciones",dropdownMenuOutput("messageMenu")),

  # Sidebar content
  dashboardSidebar(
    sidebarMenu(
      menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
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
            infoBoxOutput("infoBox"),
            valueBoxOutput("valueBox"),
            downloadButton("downloadData", "Download")),
          box( title = "Curva", status = "primary", solidHeader = TRUE, collapsible = TRUE, plotOutput("plot")),
          box( title = "tabla", status = "primary", solidHeader = TRUE, collapsible = TRUE, tableOutput("table"))
        )
      )
    )
  )
)

# Define server logic to display and download selected file ----
server <- function(input, output) {

  # Reactive value for selected dataset ----
  datasetInput <- read.csv(file="/data/test.csv", header=TRUE, sep=",")

  df1 <- fromJSON(getURL("https://proyectos.eprinsa.es/time_entries.json?limit=200&spent_on=%3E%3C2018-01-01|2018-02-01"))
  horas <- df1[["time_entries"]][["hours"]]
  actividades <- df1[["time_entries"]][["activity"]][["name"]]
  dt_act_h <- data.frame( actividades, horas)
  sumas <- aggregate(x=dt_act_h$horas, by=list(actividades=dt_act_h$actividades), FUN=sum)

  # Table of selected dataset ----
  output$table <- renderTable(sumas)

  # Downloadable csv of selected dataset ----
  output$downloadData <- downloadHandler(
    filename = function() {
      paste("nombre", ".csv", sep = "")
    },
    content = function(file) {
      write.csv(datasetInput, file, row.names = FALSE)
    }
  )

  output$messageMenu <- renderMenu({
    dropdownMenu(type = "tasks", badgeStatus = "success",
      taskItem(value = 90, color = "green", "Documentation"),
      taskItem(value = 17, color = "aqua", "Project X"),
      taskItem(value = 75, color = "yellow", "Server deployment"),
      taskItem(value = 80, color = "red", "Overall project")
    )
  })

  output$infoBox <- renderInfoBox({
    infoBox(
      "Investigaciones", nrow(datasetInput), icon = icon("flask")
    )
  })

  output$valueBox <- renderValueBox({
    valueBox(
      sum(datasetInput$num), "Total", icon = icon("list")
    )
  })

  # Fill in the spot we created for a plot
  output$plot <- renderPlot({

    # Render a barplot
    # barplot(datasetInput$field_dotacion_economica, ylab="ylab", xlab="xlab")
    ggplot(dt_act_h, aes( x=1, fill=actividades, weight=horas)) + geom_bar() + coord_polar(theta="y")

    
  })


}

# Create Shiny app ----
shinyApp(ui, server)
