# Load data ----------------------------
meeting <- read.csv("bump-chart/data/how_met_decade.tsv", sep="\t",
                    stringsAsFactors=FALSE)

# Plot a multi-line chart --------------------
# Blank plot
plot(meeting$year, meeting$p, type="n", xlab="year", ylab="p")

# Line for each way people meet
ways_to_meet <- unique(meeting$waymet)

for (i in 1:length(ways_to_meet)) {
  
  # Points for current way to meet.
  curr <- meeting[meeting$waymet == ways_to_meet[i],]
  curr <- curr[order(curr$year),]
  
  # Line.
  lines(curr$year, curr$p)
}

# Plot a bump chart -----------------------------
# Create a rank column
meeting$rank <- NA
years <- unique(meeting$year)
for (i in 1:length(years)) {
  
  # Ranks for current year.
  curr_ranks <- rank(meeting[meeting$year == years[i], "p"])
  
  # Reverse the ranking order.
  curr_ranks_desc <- max(curr_ranks) - curr_ranks + 1
  
  # Add to data frame.
  meeting[meeting$year == years[i], "rank"] <- curr_ranks_desc
  
}

# Blank plot, with vertical scale for rankings 
plot(meeting$year, meeting$rank, type="n",
     xlab="year", ylab="rank",
     ylim=rev(range(meeting$rank)))

# Line for each way to meet.
ways_to_meet <- unique(meeting$waymet)
for (i in 1:length(ways_to_meet)) {
  curr <- meeting[meeting$waymet == ways_to_meet[i],]
  curr <- curr[order(curr$year),]
  lines(curr$year, curr$rank)
}

# Plot a bump chart with dots and labels-----------------------
# Blank plot for ranks and adjusted margin
par(mar=c(5,4,4,10), las=1)
plot(meeting$year, meeting$rank, type="n",
     xlab="year", ylab="rank",
     ylim=rev(range(meeting$rank)),
     bty="n", xaxt="n", yaxt="n",
     main="How People Meet, by Decade")

# Custom axes.
all_ranks <- min(meeting$rank):max(meeting$rank)
axis(2, at = all_ranks, labels = all_ranks, lwd=0, lwd.ticks=.5)
axis(1,
     at = unique(meeting$year),
     labels = unique(meeting$year),
     lwd=0, lwd.ticks=.5)

# Ways to meet.
curr <- meeting[meeting$year == 2010,]
mtext(curr$waymet, at=curr$rank, side=4)

# Line for each way to meet.
ways_to_meet <- unique(meeting$waymet)
meet_col <- sample(colors(), length(ways_to_meet))
for (i in 1:length(ways_to_meet)) {
  curr <- meeting[meeting$waymet == ways_to_meet[i],]
  curr <- curr[order(curr$year),]
  
  # Lines.
  lines(curr$year, curr$rank, col=meet_col[i])
  
  # Points.
  points(curr$year, curr$rank, pch=21, col=meet_col[i], bg="white")
}


# Small multiples --------------------------------------
ways_to_meet <- unique(meeting$waymet)

# Four rows and five columns.
par(mfrow=c(4,5), mar=c(2,1,2,1))

# Chart for each way to meet.
for (i in 1:length(ways_to_meet)) {
  
  plot(meeting$year, meeting$rank, type="n", 
       xlab="", ylab="", 
       ylim=rev(range(meeting$rank)),
       bty="n", xaxt="n", yaxt="n",
       main=ways_to_meet[i])
  
  
  # Line for each way in the chart.
  for (j in 1:length(ways_to_meet)) {
    curr <- meeting[meeting$waymet == ways_to_meet[j],]
    curr <- curr[order(curr$year),]
    
    if (ways_to_meet[j] == ways_to_meet[i]) {
      col <- "purple"
      lwd <- 1
      cex <- 1
    } else {
      col <- "lightgray"
      lwd <- .5
      cex <- .5
    }
    
    # Lines.
    lines(curr$year, curr$rank, col=col)
    
    # Points.
    points(curr$year, curr$rank, pch=21, col=col, bg="white", cex=cex)
  }
}














