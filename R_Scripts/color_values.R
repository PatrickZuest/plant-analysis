main <- function(Overview){
  for(i in 0:4720){
    Overview <- getColor(i, Overview)
  }
    Overview
}


searchInSummary <- function(searchTerm) {
  results <- grep(searchTerm, Summary$name, value=FALSE)
  results
}

showValue <- function(results,i){
  value <- Summary$color[results[i]]
  value <- as.numeric(levels(value))[value]
  value
}

getColor <- function(rowNumber, Overview){
  results <- searchInSummary(Overview$Combined2[rowNumber])
  Overview$red[rowNumber]<-showValue(results,1)
  Overview$blue[rowNumber]<-showValue(results,2)
  Overview$white[rowNumber]<-showValue(results,3)
  Overview
}