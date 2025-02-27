## Simplified version of annotate.R

## Parameter for plotting
## Set x variable for the fitness function 
x = seq(-1, 7.5, by = .01)

## Math parameters for Fitness function 
s = .5
m = 1.5
t = 1.7
u = 3.4
div1 = 2.4
div2 = 3.5

## Set population parameters
## NB individuals, try with 10, and 1000 
n = 1000 
## Get fake phenotypes
## Phenotypes for the population
pheno = rnorm(n = n, mean = 3.2, sd = 0.5) 
## Make y height just for vizualisation purpose 
fit = rnorm(length(pheno), mean = .12, sd =.01)


## Load functions ----------------------------------------------------------
## Mathematical fitness function (2 peaks )
## This is a speculative fitness function, you could design your own.
fit.function  <- function(x, s, m, t, u, div1 = 2, div2 = 2.5) {
    exp(-s^(-2)*(x-m)^(2))/div1+exp(-t^(-2)*(x-u)^(2))/div2
}

main.plot <- function(mar = c(3, 3, .25, .25), col = 2) {
    ## Set parameter of plotting area 
    par(mar = mar)
    ## Plot fitness function 
    y = fit.function(x = x,s = s, m = m,t = t,u = u, div1 = div1, div2 = div2)
    plot(y ~ x, 
         xlim = c(-0.5, 7),
         ylim = c(0, .7),
         axes=FALSE,
         type = "l", lwd = 5, col = col, 
         ylab = "Fitness", xlab = "Phenotypes")
    axis(1)
    axis(2, at=seq(0, .6, .2))
    box()
}

## Make a fake population 
add.fake.pop =  function(x = pheno, y = fit,  alp = 1) {
    ## Line at the mean 
    ## abline(v = mean(x), lty = 3)
    ## Calculate the density of the population 
    dens.xy = density(x = x, n = 512, adjust = 2) # Adjust to make it smoother 
    ## Add density 
    lines(x = dens.xy$x, y = dens.xy$y/3, lty = 2)
}

## Draw plots --------------------------------------------------------------

if (exists("PNG") && PNG) {
    png("simplified.png",
        width = 7, height = 4.5,units = "in", res = 300,
        pointsize = 12, bg = "white")
    dev.control("enable")
}

par(family="TeX Gyre Adventor", mgp=c(2, .7, 0))
main.plot();
add.fake.pop(alp = .1); 

library(gridGraphics)
grid.echo()
downViewport("graphics-window-1-1")

library(xdvir)
runonce <- function() {
    author(readLines("simplified-source.tex"),
           engine=lualatexEngine,
           packages="xcolor",
           texFile="simplified.tex")
    typeset("simplified.tex", engine=lualatexEngine)
}

simplifiedDVI <- readDVI("simplified.dvi")
grid.dvi(simplifiedDVI,
         packages="xcolor",
         x=unit(1, "npc") - unit(5, "mm"), y=unit(1, "npc") - unit(5, "mm"),
         hjust="right", vjust="top")

  
if (exists("PNG") && PNG) {
    dev.off()
}

