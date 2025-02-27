
## https://stackoverflow.com/questions/75889406/typing-long-text-in-legend-with-automatic-line-return-and-mathematical-notation

plot(1:10)
text.explain = "This is some quite long text where I want to add math notation stuff like z bar_i and continue to explain other stuff adding further math notation like this (W bar_i), but it is not doing what I want"

legend(x =6, y = 5,
       legend = paste0(strwrap(bquote(.(text.explain)), 37), collapse = "\n"), bty = "n")
title = list("This is some quite long text where I want to",
             bquote("add math notation stuff like"~bar(z)~"and continue"),
             "to explain other stuff adding further math",
             bquote("notation like this"~bar(W)~", but it is not "),
             "doing what I want.")
leg = do.call(expression, title)
legend(x =1, y = 8,
       y.intersp = 1.7,
       legend =  leg
       , bty = "n")


## 'xdvir' solution

## remotes::install_github("pmur002/xdvir")
## PLUS a TeX installation and 'fonttools'
library("xdvir")

png("demo.png", width=700, height=700, res=100)
plot(1:10)
grid.latex("\\begin{minipage}{2.5in}\\LARGE This is some quite long text where I want to add math notation stuff like $\\bar z_i$ and continue to explain other stuff adding further math notation like this $\\bar W_i$, but it is not doing what I want\\end{minipage}", x=.15, y=.8, hjust="left", vjust="top")
dev.off()
