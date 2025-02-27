# Description -------------------------------------------------------------
### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###
# Created by Marc-Olivier Beausoleil
# McGill University 
# Created March 1, 2023 
# Why:
    # Animation that shows how an adaptive landscape is calculated based on the fitness function (landscape)
# Requires 
    # ImageMagick and FFMPEG
    # All required functions are within the script 
# NOTES: 
    # You can play with a mathematical equation to see what you to see 
    # https://www.desmos.com/calculator
    # You can use the image_animate() function to lengthen or shorten the time to see a particular frame 
### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###
library(viridis)

wide = FALSE

# Folder path 
export.path = "output/adaptive_land.animation/_fitplot.gif"
dir.create(export.path, showWarnings = FALSE, recursive = TRUE)
# Name of gif 
gif.name = "animated.adaptive.landscape.example.gif"

# You can print an adaptive landscape for a population with more variance in their phenotypes
if(wide){
  export.path = "output/adaptive_land.animation/_fitplot_wide.gif"
  gif.name = "animated.adaptive.landscape.example_wide.gif"
}

set.seed(1234)
# Parameter for plotting
# Set x variable for the fitness function 
x = seq(-1,7,by = .01)

# Math parameters for Fitness function 
s = .5
m = 1.5
t = 1.7
u = 3.4
div1 = 2.4
div2 = 3.5

# Set population parameters  
n = 1000 # NB individuals, try with 10, and 1000 
# Get fake phenotypes 
pheno = rnorm(n = n, mean = 3.2, sd = 0.5) # Phenotypes for the population
# Make y height just for vizualisation purpose 
fit = rnorm(length(pheno), mean = .12, sd =.01)


# Load functions ----------------------------------------------------------
# Will redraw the plot to add points for gif 
reset.plot = function(mar = c(4,4,.25,.25), col = "red") {
  # Set parameter of plotting area 
  par(mar = mar)
  # Plot fitness function 
  y = fit.function(x = x,s = s, m = m,t = t,u = u, div1 = div1, div2 = div2)
  plot(y~x, 
       xlim = c(-0.5,6),
       ylim = c(0,.8),
       type = "l", lwd = 5, col = col, 
       ylab = "Fitness", xlab = "Phenotypes")
  
}
# Draw arrow to specific location 
add.arrow.text = function(dvi, x, y, xoff=unit(1, "cm"), yoff=unit(1, "cm"),
                          col = "red", ...) {
    grid.dvi(dvi,
             x=unit(x[1], "native") - xoff - unit(1, "mm"),
             y=unit(y[1], "native") + yoff,
             hjust="right", vjust="baseline")
    grid.segments(x1=x[1], y1=y[1], default.units="native",
                  x0=unit(x[1], "native") - xoff,
                  y0=unit(y[1], "native") + yoff,
                  ## arrow=arrow(angle = 26, length = unit(.1, "in")), 
                  gp=gpar(col = col, lwd = 1))
}

# Make a fake population 
add.fake.pop =  function(x = pheno, y = fit,  alp = 1) {
  # Add pop to plot 
  points(x = x, y = y, col = scales::alpha("black", alpha = alp), cex = .2) 
  # Add population mean 
  points(mean(x), y = mean(y), pch = 21, bg = scales::alpha("grey50", .9), col = "black", cex = 2.5)
  # Line at the mean 
  abline(v = mean(x), lty = 3)
  # Calculate the density of the population 
  dens.xy = density(x = x, n = 512, adjust = 2) # Adjust to make it smoother 
  # Add density 
  lines(x = dens.xy$x, y = dens.xy$y/3, lty = 2)
}

# Mathematical fitness function (2 peaks )
# This is a speculative fitness function, you could design your own.
fit.function  <- function(x,s,m,t,u, div1 = 2, div2 = 2.5) (
  exp(-s^(-2)*(x-m)^(2))/div1+exp(-t^(-2)*(x-u)^(2))/div2
)


# Adds a legend to the plot 
add.legend <- function(variables) {
  legend("topright",
         legend = c("Population", 
                    "Fitness function",
                    "Phenotypic distribution",
                    "Recentered population",
                    "Adaptive landscape"),
         col = c("black",
                 "red",
                 "black",
                 viridis(5, alpha = .5)[2],
                 "black"),
         pt.bg = c("black",
                   "red",
                   viridis(3)[2],
                   viridis(5, alpha = .5)[2],
                   viridis(3)[3]),
         bg = scales::alpha("white",.5),
         lty = c(NA,1,
                 2,NA,NA,NA,NA),
         lwd = c(NA,3,
                 2,NA,NA,NA,NA),
         pch = c(21,NA,
                 NA,21,21,21,21),
         bty = "n")
}

add.pop.moved = function(index, y = fit, col = viridis(5, alpha = .5)[2], seed = 123456) {
  if (!is.null(seed)) {
    set.seed(seed)
  }
  # Add fake points of population traits
  points(list.fun[[index]]$pop.traits, y = y-hpop,                           pch = 21, col = col,cex = .2) # y pos before rnorm(length(list.fun[[5]]$pop.traits), mean = hpop, sd =.01)
  # Mean of population 
  points(list.fun[[index]]$mean.pheno, y = mean(y)-hpop,                     pch = 21, bg = col, cex = 2.5)
  # Point on the fitness landspcae 
  points(list.fun[[index]]$mean.pheno, y = list.fun[[index]]$adapt.mean.fit, pch = 21, bg = col, cex = 1)
  # Point on adaptive landscape 
  points(list.fun[[index]]$mean.pheno, y = list.fun[[index]]$mean.fit,       pch = 21, bg = col, cex = 1)
}

add.segments.to.fit = function(x, n, alpha.lvl = .1, add.points = FALSE) {
  segments(x0 = x, 
           x1 = x, 
           y0 = 0, 
           y1 = fit.function(x = x, s,m = m,t = t,u = u, div1 = div1, div2 = div2),
           col = scales::alpha("black",alpha.lvl))
  if (add.points) {
    points(x = pheno, 
           y = fit.function(x = pheno, s,m = m,t = t,u = u, div1 = div1, div2 = div2), pch = 19, cex = 1.1)  
  }
}


# Draw plots --------------------------------------------------------------

if (PNG) {
    png("annotate.png",
        width = 7,height = 4.5,units = "in", res = 300,
        pointsize = 12, bg = "white")
    dev.control("enable")
}

# Frame 6+++
# setting variables to record values for the adaptive landscape 
adapt.line = NULL
adapt.x = NULL
list.fun = list()
# For loop to get the adaptive landscape values 
extend = 2 # How far from the mean phenotype should you go 

for (i in seq(mean(pheno)*extend,-mean(pheno)*extend, by = -0.01)) {

  pheno.moved = pheno - i # Move the population mean (by moving each individual points)
  fit.out = fit.function(x = pheno.moved, s = s, m = m,t = t,u = u, div1 = div1, div2 = div2) # get the fitness of each individual in the simulated population 
  adapt.x = c(adapt.x, mean(pheno.moved)) # record the position of phenotype for the mean 
  adapt.line = c(adapt.line, mean(fit.out)) # record mean fitness of population
  
  # Iterate points 
  adapt.mean.fit = fit.function(x = mean(pheno.moved), s = s, m = m,t = t,u = u, div1 = div1, div2 = div2)
  list.fun[[length(list.fun) + 1]] =  list(mean.fit = mean(fit.out), 
                                           mean.pheno = mean(pheno.moved), 
                                           adapt.mean.fit = adapt.mean.fit,
                                           pop.traits = pheno.moved,
                                           fit.out = fit.out)
}

length(list.fun)
hpop = 0
index1 = 350
index2 = 580
index3 = 850

# Will record the position of each points 
x.adapt.all = NULL
y.adapt.all = NULL

par(family="TeX Gyre Adventor")

for (j in seq(250, 1000, by = 10)) {
    
    ## Get the x position
    x.adapt = list.fun[[j]]$mean.pheno
    ## Get the y position
    y.adapt = list.fun[[j]]$mean.fit
    ## Keep track of the positions for each iteration
    x.adapt.all = c(x.adapt.all, x.adapt)
    y.adapt.all = c(y.adapt.all, y.adapt)

    if (j == 440) {
        yAdapt <- y.adapt
        
        ## Make the same plot as before but change certain plotting information 
        reset.plot();add.fake.pop(alp = .1); 
        points(mean(pheno), 
               mean(fit.function(x = pheno, s,m = m,t = t,u = u,
                                 div1 = div1, div2 = div2)), pch = 19)
        
        ## Add points of the moved population (moved based on the averge of the traits)
        add.pop.moved(index = j, col = viridis(5, alpha = .2)[2])
        ## Add segments to show what would be expected fitness 
        add.segments.to.fit(x = list.fun[[j]]$pop.traits, n = n,
                            alpha.lvl = .01)
        
        points(x.adapt.all, y.adapt.all, pch = 21, bg = viridis(3)[3], cex = 1)
        
        ## Add the same legend each time 
        add.legend()
    }
  
}

library(gridGraphics)
grid.echo()
downViewport("graphics-window-1-1")

library(xdvir)
runonce <- function() {
    author("\\setmainfont{texgyreadventor}\\fontsize{12}{15}\\selectfont\\begin{minipage}{3in}We `move' the original population's mean to a new $\\bar z_i$ and calculate the average fitness at that new mean phenotype, $\\bar W_i$, of the population to get the adaptive landscape.\\end{minipage}",
           engine=lualatexEngine,
           texFile="annotate.tex")
    typeset("annotate.tex", engine=lualatexEngine)
    author("\\setmainfont{texgyreadventor}\\fontsize{12}{15}\\selectfont $\\bar z$",
           engine=lualatexEngine,
           texFile="barz.tex")
    typeset("barz.tex", engine=lualatexEngine)
    author("\\setmainfont{texgyreadventor}\\fontsize{12}{15}\\selectfont $\\bar W_i$",
           engine=lualatexEngine,
           texFile="barwi.tex")
    typeset("barwi.tex", engine=lualatexEngine)
    author("\\setmainfont{texgyreadventor}\\fontsize{12}{15}\\selectfont $\\bar z_i$",
           engine=lualatexEngine,
           texFile="barzi.tex")
    typeset("barzi.tex", engine=lualatexEngine)          
    author("\\setmainfont{texgyreadventor}\\fontsize{12}{15}\\selectfont $f(z) = \\hat W$",
           engine=lualatexEngine,
           texFile="fz.tex")
    typeset("fz.tex", engine=lualatexEngine)          
}

                  
annotateDVI <- readDVI("annotate.dvi")
grid.dvi(annotateDVI,
         x=unit(5, "mm"), y=unit(1, "npc") - unit(5, "mm"),
         hjust="left", vjust="top")

barz <- readDVI("barz.dvi")
add.arrow.text(barz, x = mean(pheno), y = mean(fit),
               xoff=unit(5, "mm"), yoff=unit(5, "mm"),
               col = "black")
## Adding the zbar information 
barzi <- readDVI("barzi.dvi")
add.arrow.text(barzi,
               x = list.fun[[440]]$mean.pheno, y = mean(fit)-hpop,
               col = "blue4")
## Adding the adaptive landscape information 
barwi <- readDVI("barwi.dvi")
add.arrow.text(barwi,
               x = list.fun[[440]]$mean.pheno, y = yAdapt,
               col = "goldenrod3")
## Adding the f(z) landscape information 
fz <- readDVI("fz.dvi")
add.arrow.text(fz,
               x = list.fun[[440]]$mean.pheno,
               y = list.fun[[440]]$adapt.mean.fit,
               col = "red")
  
if (PNG) {
    dev.off()
}

