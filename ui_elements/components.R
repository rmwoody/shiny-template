library(glue)
library(shiny)
customNav <- function(...){
  items <- list(...)
  html <- div(class="navbar navbar-expand-lg fixed-top navbar-dark bg-dark",
              div(class = "container-fluid", style = 'align-items: center;',
                  # tags$link(rel="icon", href="img/favicon_io/favicon-32x32.png"), 
                  tags$div(class = "navbar-brand",
                           href="javascript:setPage('home');", 
                           "ShinyMeNot"),
                  div(id="navbarResponsive",class= "collapse navbar-collapse",
                      tags$ul(class="navbar-nav",
                              mapply(function(x){
                                return(uiOutput(x))
                              },x = items, SIMPLIFY = FALSE, USE.NAMES = FALSE
                              ),
                              uiOutput("normal")
                      )     # Nothing is rendered on startup.
                  )
              )
  )
  return(html)
}

customNavDown <- function(id= NULL, dropdownName, ...){
  items = list(...)
  tagList(
    tags$li(class="nav-item dropdown",
            tags$a(class="nav-link dropdown-toggle", id = id,
                   `data-toggle`="dropdown",
                   href="#",
                   dropdownName),
            div(class = 'dropdown-menu',`aria-labelledby` = "themes",
                items
            )
    )
  )
}

moduleDropdownLink <- function(label,moduleName,divider = FALSE){
  if (divider){
    divider <- tags$div(class = "dropdown-divider")
  } else{divider <- ""}
  return(tags$a(class = 'dropdown-item',
                href = paste0("javascript:setPage('",moduleName,"');"),
                label,
                divider)
  )
}

custBrand <- function(module_name,label = NULL,...){
  tags$a(class="navbar-brand",
         href = paste0("javascript:setPage('",module_name,"');"),
         label,
         list(...))
} 


custNav <- function(id = NULL,label = NULL, module_name=NULL,...){
  items <- list(...)
  tags$li(class="nav-item",
          tags$a(class="nav-link",
                 href = paste0("javascript:setPage('",module_name,"');"),
                 label,
                 items)
  )
}



custNavBar <- function(brand,...){
  items <- list(...)
  tags$div(class="navbar navbar-expand-md navbar-dark bg-dark fixed-top",
           brand,
           tags$button(class="navbar-toggler",type="button", `data-toggle`="collapse" ,
                       `data-target`="#navbarsExampleDefault" ,
                       `aria-controls`="navbarsExampleDefault" ,
                       `aria-expanded`="true", `aria-label`="Toggle navigation",
                       tags$span(class="navbar-toggler-icon")
           ),
           tags$div(class="navbar-collapse collapse show", id="navbarsExampleDefault" ,style="",
                    tags$ul(class="navbar-nav mr-auto",
                            items
                    )
           )
  )
}
custDropItem <- function(id = NULL,label=NULL,module_name = NULL){
  tags$a(class="dropdown-item",
         href = paste0("javascript:setPage('",module_name,"');"),
         label
  )
}


custNavBar(custBrand(label = "ShinyMeNot",module_name = 'landing'),
           custNav(label = "Home",module_name = 'home'),
           custNav(id = "login_user",label = "login",module = "login")
)



