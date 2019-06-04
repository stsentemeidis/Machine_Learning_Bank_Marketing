###
### THIS APP ALLOW TO DISPLAY RELEVANT PLOTS FOR THE DATASET
###


# Load Packages
library('ggthemes')
library('ggplot2')
library('grid')
library('gridExtra')
library('shiny')

# Load Data
df <- readRDS('data/bank_train.rds')

# Define UI for application
ui <- fluidPage(
    wellPanel(
        selectInput(
            inputId = 'feature',
            label = 'Feature',
            choices = sort(names(df)),
            selected = 'age'
        )
    ),
    wellPanel(textOutput('class_feat')),
    conditionalPanel("output.class_feat == 'factor'",
                     plotOutput("fact_plot_1", height = 300)),
    conditionalPanel("output.class_feat == 'factor'",
                     plotOutput("fact_plot_2", height = 300)),
    conditionalPanel("output.class_feat != 'factor'",
                     plotOutput("num_plot_1", height = 300)),
    conditionalPanel("output.class_feat != 'factor'",
                     plotOutput("num_plot_2", height = 300))
)

# Define server logic
server <- function(input, output) {
    
    output$class_feat <- reactive({
        class_feat <- class(df[, input$feature])
    })
    
    output$fact_plot_1 <- renderPlot({
        ggplot(df,
               aes(x = df[, input$feature])) +
            geom_bar(color = 'darkcyan', fill = 'darkcyan') +
            theme_minimal() +
            labs(x = input$feature, y = 'Count')
    })
    
    output$fact_plot_2 <- renderPlot({
        ggplot(df,
               aes(x = df[, input$feature], y = y)) +
            geom_boxplot(color = 'darkcyan') +
            theme_minimal() +
            theme(legend.position = 'none') +
            labs(x = input$feature, y = 'Subscribed')
    })
    
    output$num_plot_1 <- renderPlot({
        ggplot(df,
               aes(x = df[, input$feature])) +
            geom_density(color = 'darkcyan', fill = 'darkcyan') +
            theme_minimal() +
            theme(
                legend.position = 'none',
                plot.title = element_text(
                    hjust = 0.5,
                    size = 12,
                    face = 'bold'
                )
            ) +
            labs(x = '',
                 y = 'Density',
                 title = paste0(toupper(substr(input$feature, 1, 1)), tolower(substr(
                     input$feature, 2, nchar(input$feature)
                 ))))
        })
    
    output$num_plot_2 <- renderPlot({
        ggplot(df,
               aes(x = df[, input$feature], y = y)) +
            geom_point(color = 'darkcyan', size = 0.5) +
            theme_minimal() +
            theme(legend.position = 'none') +
            labs(x = '', y = 'Subscribed')
    })
    
}

# Run the application 
shinyApp(ui = ui, server = server, options = list(height = 800))
