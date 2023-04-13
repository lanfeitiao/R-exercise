getColors <- function(values, breaks, col, missing_col) {
  
  if (length(breaks) != length(col)-1) {
    stop("The length of breaks must be one less than the length of col.")
  }
  colors <- sapply(values, function(x) {
    
    if (is.na(x)) {
      return(missing_col)
    } else if (x >= max(breaks)) {
      return(col[length(col)])
    }
    else {
      i <- min(which(breaks > x))
      return(col[i])
    }
  })
  return(colors)
}