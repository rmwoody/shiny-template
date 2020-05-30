


simple_card <- function(id,title=NULL,subtitle=NULL, ...,style='padding:15px;'){
  items <- list(...)
  tags$div(id = id, class = "card",style = style,
  tags$div(class = "card-body",
           h3(class = "card-title", title),
           h5(class = "card-subtitle mb-2 text-muted", subtitle),
           hr(),
  items
  )
)
}
dashboardCard <- function(id = NULL,...,style='padding:15px;'){
  items <- list(...)
  tags$div(id = id, class = "card",style = style,
           tags$div(class = "card-body",
                    items
           )
  )
}






  
  
  
  