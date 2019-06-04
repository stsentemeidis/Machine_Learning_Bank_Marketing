###
### THIS APP ALLOW TO DISPLAY A DASHBOARD FOR MODELS
###


# Load Packages
library('shiny')
library('shinydashboard')

# Load Data
results <- readRDS('data/all_real_results.rds')


# Define UI for application
ui <- dashboardPage(
    dashboardHeader(title = "Models Dashboard"),
    dashboardSidebar(
        selectInput(
            inputId = 'model',
            label = 'Model',
            choices = rownames(results)
        )
    ),
    dashboardBody()
)

# Define server logic
server <- function(input, output) {
    
    
}

# Run the application 
shinyApp(ui = ui, server = server, options = list(height = 500))
