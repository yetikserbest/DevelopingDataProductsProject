library(shiny)
data(mtcars)
fit <- lm(mpg ~ factor(am) + wt + factor(cyl) + hp, data=mtcars)

shinyServer(function(input,output){
  output$plot <- renderPlot({
    l <- qnorm((1-input$confint)/2)
    h <- -l
    curve(dnorm(x,0,1), xlim=c(-3,3), main="Confidence Interval")
    from.z <- -3
    to.z <- l
    S.x  <- c(from.z, seq(from.z, to.z, 0.01), to.z)
    S.y  <- c(0, dnorm(seq(from.z, to.z, 0.01)), 0)
    polygon(S.x,S.y, col="red")
    from.z <- h
    to.z <- 3
    S.x  <- c(from.z, seq(from.z, to.z, 0.01), to.z)
    S.y  <- c(0, dnorm(seq(from.z, to.z, 0.01)), 0)
    polygon(S.x,S.y, col="red")
    from.z <- l
    to.z <- h
    S.x  <- c(from.z, seq(from.z, to.z, 0.01), to.z)
    S.y  <- c(0, dnorm(seq(from.z, to.z, 0.01)), 0)
    polygon(S.x,S.y, col="green")    
  })
  
  output$result <- renderPrint({
    predict(fit,newdata=list(am=factor(input$transmission),wt=as.numeric(input$weight),cyl=factor(input$cylinder),hp=as.numeric(input$horsepower)),interval=("confidence"), level=input$confint)
  })
})