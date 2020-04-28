## @knitr variablesXY
# source(here("/R/example2.R"))

x<-1:100
y<-x+rnorm(100)
head(data.frame(x,y))

## @knitr plotXY

plot(x,y)
