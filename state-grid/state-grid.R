# Load coordinates data ---------------------------
stategrid <- read.csv("state-grid/data/state-grid-coordinates.tsv", 
                      stringsAsFactors = FALSE, sep="\t")

# Plot coordinates data ---------------------------
# See what it looks like 
plot(stategrid$x, stategrid$y, type="n")
text(stategrid$x, stategrid$y, stategrid$state)

# It's upside down. Flip it.
stategrid$ysideup <- 12 - stategrid$y

#Draw the grid
symbols(stategrid$x, stategrid$ysideup, squares = rep(1, dim(stategrid)[1]), 
        inches=FALSE, asp=1, bty="n", xaxt="n", yaxt="n", xlab="", ylab="")
text(stategrid$x, stategrid$ysideup, stategrid$state)

# Load state-level data ---------------------------
# New data file
dollarval <- read.csv("state-grid/data/dollarval-bystate.tsv",
                      stringsAsFactors = FALSE, sep="\t")
# Merge grid coordinates data frame with new data.
dollargrid <- merge(dollarval, stategrid, by.x="abbrev", by.y="state")
# Add color 
dollargrid$col <- sapply(dollargrid$value_100, function(x) {
  if (x < 95) {
    col <- "#011e00"
  } else if (x < 100) {
    col <- "#024000"
  } else if (x < 105) {
    col <- "#047300"
  } else if (x < 110) {
    col <- "#06a600"
  } else {
    col <- "#07c800"
  }
  return(col)
})

# Plot state-level data -----------------------------
symbols(dollargrid$x, dollargrid$ysideup,
        squares = rep(1, dim(dollargrid)[1]),
        inches=FALSE,
        asp=1,
        bty="n",
        xaxt="n", yaxt="n",
        xlab="", ylab="",
        bg=dollargrid$col,
        fg="#ffffff")
labeltext <- paste(dollargrid$abbrev, "\n", "$", 
                   format(dollargrid$value_100, 2), sep="")
text(dollargrid$x, dollargrid$ysideup, labeltext, cex=.6, col="#ffffff")

# Add legend ------------------------------------------
# Start layout
par(mar=c(0,0,0,0), bg="white")
plot(0:1, 0:1, type="n", xlab="", ylab="", axes=FALSE, asp=1)

# Draw map like before.
par(new=TRUE, plt=c(0, 1, 0, 1))
symbols(dollargrid$x, dollargrid$ysideup,
        squares = rep(1, dim(dollargrid)[1]),
        inches=FALSE,
        asp=1,
        bty="n",
        xaxt="n", yaxt="n",
        xlab="", ylab="",
        bg=dollargrid$col,
        fg="#ffffff")
labeltext <- paste(dollargrid$abbrev, "\n", "$", format(dollargrid$value_100, 2), sep="")
text(dollargrid$x, dollargrid$ysideup, labeltext, cex=.8, col="#ffffff")
# Legend
# Create a new plotting area placed up top
par(new=TRUE, plt=c(0, 1, .9, 1))
plot(0, 0, type="n", xlim=c(0, 1), ylim=c(-.1,1), xlab="", ylab="", axes=FALSE)
# Draw the rectangles
rect(xleft = c(.4, .45, .5, .55, .6)-.025,
     xright = c(.45, .5, .55, .6, .65)-.025,
     ybottom = c(0,0,0,0,0)+.1, ytop=c(.2, .2, .2, .2, .2)+.1,
     col=c("#011e00", "#024000", "#047300", "#06a600", "#07c800"),
     border="#ffffff", lwd=.5)
# Label the color breaks 
text(c(.45, .5, .55, .6)-.025, c(0,0,0,0)-.3, 
     labels = c("$95", "$100", "$105", "$110"), pos=3, cex=.8)

# Add title
text(.5, .7, "Value of $100", cex=2)
