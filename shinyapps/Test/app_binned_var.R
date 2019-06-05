ui <- fluidPage(
  titlePanel("Histograms of Numerical Variables"),
  sidebarLayout(
    sidebarPanel(
      selectInput("var", 
                  label = "Choose a variable to display",
                  choices = c('age', 'balance', 'duration', 'campaign'),
                  selected = "age")),
    mainPanel(
      plotOutput("binplot")
    )
  )
)

server <- function(input, output) {
  
  # Fill in the spot we created for a plot
  output$binplot <- renderPlot({
    #bank_train_plots[, input$var] <- as.numeric(bank_train_plots[, input$var])
    #bank_train_plots[, input$var] <- log(bank_train_plots[, input$var])
    ggplot(bank_train_plots, aes(x = bank_train_plots[, input$var])) + 
      geom_histogram(color = "darkcyan", fill = "darkcyan", alpha = 0.4) + 
      geom_vline(xintercept = quantile(bank_train_plots[, input$var], seq(0, 1, by = 1 / 4)), colour = "firebrick3", size = 1) + 
      theme_minimal() + 
      theme(panel.grid.major = element_blank(),
            panel.grid.minor = element_blank(),
            panel.border = element_blank())

  })
}

# Run the application 
shinyApp(ui = ui, server = server)



