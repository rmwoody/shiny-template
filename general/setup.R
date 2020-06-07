# Should Include All packages needed for the app
all.packages <- function(file){
  text <- readLines(file)
  keep <- unlist(lapply(text,function(x) grepl(pattern = "^library\\(.+\\)",x)))
  packages <- gsub( "\\)","",gsub("(^library)\\(","",text[keep]))
  return(packages)
}


new.packages <- function(packages){
  v <- lapply(packages, function(x){
    !x %in% (row.names(installed.packages()))
  })
  return(packages[unlist(v)])
}

install.new.packages <- function(packages){
  if(length(packages) < 1){
    return(NULL)
  }else{
    install.packages(packages)
  }
}

libraries <- function(packages){
  for (pkg in packages){
    do.call("library",args = list(pkg))
  }
}