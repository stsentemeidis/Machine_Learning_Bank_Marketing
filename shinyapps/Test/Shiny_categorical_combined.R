
ui <- fluidPage(
    titlePanel("Plot of categorical Variables"),
    sidebarLayout(
      sidebarPanel(
        selectInput("var", 
                    label = "Choose a variable to display",
                    choices = c("default",
                                "housing",
                                "loan",
                                "job",
                                "marital",
                                "education",
                                "contact",
                                "month",
                                "poutcome",
                                "y"
                    ),
                    selected = "default")),
      mainPanel(
        plotOutput("barplot")
      )
    )
  )


# Define server logic required to draw a histogram
server <- function(input, output) {
  
  # Fill in the spot we created for a plot
  output$barplot <- renderPlot({
    
    catcols <- c("default","housing","loan","job","marital","education","contact","month","poutcome","y")
    for (i in catcols){
    bank_train_plot[, i] <- as.factor(bank_train_plot[,i])}
      p1 <-  ggplot(bank_train_plot, aes_string(x= bank_train_plot[, input$var])) +
          geom_bar(fill = color4)+
          theme_tufte(base_size = 5, ticks=F)+
          theme(plot.margin = unit(c(10,10,10,10),'pt'),
                axis.title=element_blank(),
                axis.text = element_text(colour = color2, size = 7, family = font2),
                axis.text.x = element_text(hjust = 1, size = 7, family = font2, angle = 45),
                legend.position = 'None',
                plot.background = element_rect(fill = color1))
      
    catcols <- c("default","housing","loan","job","marital","education","contact","month")
    for (var in input) {
      mytable <- table(bank_train_plot[, input$var], bank_train_plot$y)
      tab <- as.data.frame(prop.table(mytable, 2))
      colnames(tab) <-  c('var', "y", "perc")
        
      }
      p2 <- ggplot(data = tab, aes(x = var , y = perc)) + 
        geom_bar(aes(fill = y),stat = 'identity', position = 'dodge', alpha = 2/3) + 
        theme(axis.text.x=element_text(size=10, angle=90,hjust=0.95,vjust=0.2))+
        xlab("Job")+
        ylab("Percent")+
        theme_tufte(base_size = 5, ticks=F)+
        theme(plot.margin = unit(c(10,10,10,10),'pt'),
              axis.title=element_blank(),
              axis.text = element_text(colour = color3, size = 10, family = font2),
              axis.text.x = element_text(hjust = 1, size = 10, family = font2, angle = 45),
              legend.position = 'None',
              plot.background = element_rect(fill = color1))
      
      grobs <- list()
      
      grobs[[1]] <- p1
      
      grobs[[2]] <- p2
      
      grid.arrange(grobs = grobs)
      
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
