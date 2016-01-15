library(shiny)
library(ggplot2)
library(pwr) #useful because can use effect size rather than calculate manually
library(ggthemes)

# Define server logic required to summarize and view the selected
# dataset
shinyServer(function(input, output) {
  
  # Expression that generates a histogram. The expression is
  # wrapped in a call to renderPlot to indicate that:
  #
  #  1) It is "reactive" and therefore should be automatically
  #     re-executed when inputs change
  #  2) Its output type is a plot
  
  Q <- reactive({
    
    # Compose data frame
    data.frame(
      Name = c("es", 
               "powerLevel",
               "alpha",
               "type",
               "alternative"),
      Value = c(input$es, input$powerLevel, input$alpha, input$type, input$alternative))
    
    myType <-  switch(input$type, 
                      "two sample" = "two.sample",
                      "paired" = "paired")
    
    myAlt <-  switch(input$alternative, 
                     "two-sided" = "two.sided",
                     "one-sided" = "greater")
    
    c(myType, myAlt)
  }) 
  
    output$summary <- renderPrint({
  
      Q()[1]
  
    })
  
  output$distPlot <- renderPlot({
    
#     myType <- as.character(Q()[1])
#     myAlt <- as.character(Q()[2])

    
    esizes <- seq(from=.1, to=.8, by=.01)
    p <- numeric(length(esizes))
    k <- 1
    for(i in esizes){
      p[k] <- pwr.t.test(n=NULL, d=i, sig.level=input$alpha, power=input$powerLevel, 
                         type=Q()[1],
                         alternative=Q()[2])$n
      k <- k + 1
    }
    espoint <- pwr.t.test(n=NULL, d=input$es, sig.level=input$alpha, power=input$powerLevel, 
                          type=Q()[1],
                          alternative=Q()[2])$n
    if(input$type=="two sample"){totaln <- espoint*2}
    else{totaln<-espoint}

    
    df <- data.frame(cbind(esizes, p))
    ggplot(data=df, aes(x=esizes, y=p)) +
      geom_line(color="red") +
      xlab(label="Effect Size (Cohen's d)") +
      ylab(label="n (sample size per sample)") +
      scale_x_continuous(limits=c(.1, .9), breaks=seq(.1, .9, by=.1)) +
      geom_point(x=input$es, y=espoint, size=5, color="blue") +
      geom_text(x=input$es, y=espoint, vjust=-1,
                label=paste("effect size=", round(input$es, 4), "\nn=", 
                ceiling(espoint), "\nTotal= ", ceiling(totaln), sep="")) +
      #ggtitle("by John Bradford") +
      theme_gdocs() +
      theme(axis.title.y = element_text(angle=90)) 
    
  })
  
})