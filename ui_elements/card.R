
dcard1 <- function(id = NULL, ..., title = NULL,subtitle = NULL,style = NULL){
  tags$div(id = id, 
           class = "card",style = style,
           tags$div(class = "card-body",
                    h3(class = "card-title", title),
                    h5(class = "card-subtitle mb-2 text-muted", subtitle),
                    hr(),
                    list(...)) # Content for the card
  )
}

dcard0 <- function(id = NULL, ...){
  tags$div(id = id, class = "card",
           tags$div(class = "card-body",list(...))
  ) # Content for the card)
}


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









