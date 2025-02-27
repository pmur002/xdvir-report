
left <- unit(2.2, "native")

grid.text("We `move' the original population\'s mean to",
          left, unit(1, "npc") - unit(5, "mm"),
          just=c("left", "top"))
grid.text(expression("a new "*bar(italic(z))[i]*" and calculate the average fitness"),
          left, unit(1, "npc") - unit(5, "mm") - unit(1, "lines"),
          just=c("left", "top"))
grid.text("at that new mean phenotype of the population", 
          left, unit(1, "npc") - unit(5, "mm") - unit(2, "lines"),
          just=c("left", "top"))
grid.text(expression("to get the adaptive landscape, "*bar(italic(W))[i]*", then"),
          left, unit(1, "npc") - unit(5, "mm") - unit(3, "lines"),
          just=c("left", "top"))
grid.text("we combine the population mean and the",
          left, unit(1, "npc") - unit(5, "mm") - unit(4, "lines"),
          just=c("left", "top"))
library(gridtext)
rg <- richtext_grob(paste("average fitness to get the",
                          '<span style="color: #DF536B">fitness function</span>'),
          left, unit(1, "npc") - unit(5, "mm") - unit(5, "lines"),
          hjust=0, vjust=1)  
grid.draw(rg)
