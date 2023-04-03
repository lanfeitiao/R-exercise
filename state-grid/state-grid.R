# Load data ---------------------------
stategrid <- read.csv("state-grid/data/state-grid-coordinates.tsv", 
                      stringsAsFactors = FALSE, sep="\t")

# Plot data ---------------------------

# See what it looks like 
plot(stategrid$x, stategrid$y, type="n")
text(stategrid$x, stategrid$y, stategrid$state)

