
customNav <- function(...){
  items <- list(...)
  html <- div(class="navbar navbar-expand-lg fixed-top navbar-dark bg-dark",
              div(class = "container", style = 'align-items: center;',
                  # tags$link(rel="icon", href="img/favicon_io/favicon-32x32.png"), 
                  tags$div(class = "navbar-brand",
                           href="javascript:setPage('home');", 
                           "ShinyMeNot"),
                  tags$button(class = "navbar-toggler",type="button",
                              `data-taggle`="collapse",
                              `data-target`= "#navbarResponsive",
                              `aria-controls`="navbarResponsive",
                              `aria-expanded`="false",
                              `aria-label`="Toggle navigation",
                              tags$span(class="navbar-toggler-icon")
                  ),
                  div(id="navbarResponsive",class= "collapse navbar-collapse",
                      tags$ul(class="navbar-nav",
                              mapply(function(x){
                                return(uiOutput(x))
                              },x = items, SIMPLIFY = FALSE, USE.NAMES = FALSE
                              )
                      )     # Nothing is rendered on startup.
                  )
              )
  )
  return(html)
}

moduleDropdownLink <- function(label,moduleName,divider = FALSE){
  if (divider){
    divider <- tags$div(class = "dropdown-divider")
  } else{divider <- NULL}
  return(tags$a(class = 'dropdown-item',
                href = glue("javascript:setPage('{moduleName}');") %>% as.character(),
                label,
                divider)
  )
}

navDropdown <- function(id = NULL, label = "",...){
  items = list(...)
  tags$li(class="nav-item dropdown", id = id,
          tags$a(class="nav-link dropdown-toggle",`data-toggle`="dropdown",href="#",label),
          div(class = 'dropdown-menu',`aria-labelledby` = "themes",
              items
          )
  )
}

moduleNav <- function(id = NULL,label = "", moduleName){
  tags$li(class="nav-item",
          tags$a(class="nav-link",
                 href = glue("javascript:setPage('{moduleName}');") %>% as.character(),
                 label)
  )
}

dropDivider <- function(){
  return(tags$div(class = "dropdown-divider"))
}

customNavDown <- function(id= NULL, ...){
  items = list(...)
  tagList(tags$ul(class="navbar-nav mr-auto",
                  tags$li(class="nav-item dropdown",
                          tags$a(class="nav-link dropdown-toggle", id = id,
                                 `data-toggle`="dropdown",
                                 href="#",
                                 dropdownName),
                          div(class = 'dropdown-menu',`aria-labelledby` = "themes",
                              # tags$a(class = 'dropdown-item',href = "#",
                              #        "Monthly"),
                              # tags$div(class = "dropdown-divider"),
                              # tags$a(class="dropdown-item", href="#">"Cerulean")
                          )
                          
                  )
  )
  )
}

