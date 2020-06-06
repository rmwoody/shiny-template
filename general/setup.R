# Should Include All packages needed for the app
library(dplyr)
packages <- c(
  "shiny",
  "shinydashboardPlus",
  "shinyWidgets",
  "waiter",
  "config",
  "shinyjs",
  "import",
  "dbConnect",
  "DBI",
  "R6",
  "stringr",
  "echarts4r",
  "glue",
  "tidyr",
  "dplyr",
  "DT",
  "shinythemes"
)

new.packages <- function(packages){
  v <- lapply(packages, function(x){
    !x %in% (installed.packages() %>% row.names())
  })
  return(packages[unlist(v)])
}

install.new.packages <- function(packages){
  if(length(packages) ==0){
    return(NULL)
  }else{
    install.packages()
  }
}

libraries <- function(packages){
  for (pkg in packages){
    do.call("library",args = list(pkg))
  }
}