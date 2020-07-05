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
                  # tags$button(class = "navbar-toggler",type="button",
                  #             `data-taggle`="collapse",
                  #             `data-target`= "#navbarResponsive",
                  #             `aria-controls`="navbarResponsive",
                  #             `aria-expanded`="false",
                  #             `aria-label`="Toggle navigation",
                  #             tags$span(class="navbar-toggler-icon")
                  # ),
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
                # tags$a(class = 'dropdown-item',href = "#",
                #        "Monthly"),
                # tags$div(class = "dropdown-divider"),
                # tags$a(class="dropdown-item", href="#">"Cerulean")
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

#<li class="nav-item dropdown">
#       <a class="nav-link dropdown-toggle" id="dropdown05" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">Admin</a>
#         <div class="dropdown-menu" aria-labelledby="dropdown05">
#           <a class="dropdown-item" href="javascript:setPage(\'admin_dataPreview\');">Echarts action</a>
#         </div>
#       </li>
# custDropdown <- function(id= NULL,label = NULL,...){
#   tags$li(class="nav-item dropdown",
#           tags$a(class="nav-link dropdown-toggle",
#                   id=id,
#                  `data-toggle`="dropdown",
#                  `aria-haspopup`="true" ,
#                  `aria-expanded`="false",
#                  label),
#                  tags$div(class="dropdown-menu",
#           `aria-labelledby`=id,
#           list(...)
#                  )
#           )
# }

custNavBar(custBrand(label = "ShinyMeNot",module_name = 'landing'),
           custNav(label = "Home",module_name = 'home'),
           custNav(id = "login_user",label = "login",module = "login")
)


# HTML('<nav  class="navbar navbar-expand-md navbar-dark bg-dark fixed-top">
#   <a class="navbar-brand" href="javascript:setPage(\'landing\')">ShinyMeNot</a>
#   <button class="navbar-toggler" 
#   type="button" data-toggle="collapse" 
#   data-target="#navbarsExampleDefault" 
#   aria-controls="navbarsExampleDefault" 
#   aria-expanded="true" aria-label="Toggle navigation">
#     <span class="navbar-toggler-icon"></span>
#   </button>
#   <div class="navbar-collapse collapse show" id="navbarsExampleDefault" style="">
#     <ul class="navbar-nav mr-auto">
#       <li class="nav-item active">
#         <a class="nav-link" href="javascript:setPage(\'landing\')";>Home <span class="sr-only">(current)</span></a>
#       </li>
#       
#       <li class="nav-item">
#         <a class="nav-link" href="javascript:setPage(\'home\')">About</a>
#       </li>
#       
#      <li class="nav-item">
#         <a class="nav-link" href="javascript:setPage(\'login\')">Login</a>
#       </li>
#       
#     
#       <li class="nav-item dropdown">
#         <a class="nav-link dropdown-toggle" id="dropdown01" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">Reporting</a>
#         <div class="dropdown-menu" aria-labelledby="dropdown01">
#           <a class="dropdown-item" href="javascript:setPage(\'reports_echarts\');">Echarts action</a>
#           <a class="dropdown-item" href="#">Something else here</a>
#         </div>
#       </li>
#       
#          <li class="nav-item dropdown">
#         <a class="nav-link dropdown-toggle" id="dropdown05" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">Admin</a>
#         <div class="dropdown-menu" aria-labelledby="dropdown05">
#           <a class="dropdown-item" href="javascript:setPage(\'admin_dataPreview\');">Echarts action</a>
#         </div>
#       </li>
#       
#       <div id="logoutbtn" class="shiny-html-output shiny-bound-output"></div>
#     </ul>
#   </div>
# </nav>'),
# 
# 
# 



