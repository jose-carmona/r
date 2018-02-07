library(shiny)
library(shinydashboard)
library(ggplot2)

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

  # Table of selected dataset ----
  output$table <- renderTable(datasetInput)

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
    ggplot(data = datasetInput) +
      geom_point(mapping = aes(x = id, y = num), color = "blue" ) +
      geom_smooth(mapping = aes(x = id, y = num))
  })


}

# Create Shiny app ----
shinyApp(ui, server)
