#######################################################
"app.R is the user specific code that runs to create 
each session. User Roles are set and specific modules
are called"
#######################################################
source("global.R")
ui <- fluidPage(theme = "css/custom-bootstrap3.css",
  tags$head(#navbarPage("djfa",
    #                      #theme = "css/pulse.css",
    #                      header = tags$img(src = "https://d1fd34dzzl09j.cloudfront.net/Images/CFACOM/Stories%20Images/2018/11/door%20dash/2web.jpg?h=960&w=1440&la=en"),
    #                      navbarMenu("More",
    #                                 tabPanel("Summary"),
    #                                 "----",
    #                                 "Section header",
    #                                 tabPanel("Table")
    #                      ),
    # Custom CSS and JavaScript
    tags$script(src = "js/custom.js"),  
    #tags$link(rel = "stylesheet", type = "text/css", href = "css/custom-bootstrap.css"),
    tags$link(rel = "stylesheet", type = "text/css", href = "css/customyeti.css"),
    tags$link(rel="stylesheet",type = "text/css",
              href="highlight/styles/atom-one-dark.css"),
    tags$script(src="highlight/highlight.pack.js"),
    tags$script("hljs.initHighlightingOnLoad();")
  ),
  
  #Shiny.setInputValue(id, value);
  #https://shiny.rstudio.com/articles/communicating-with-js.html
  # The Possible Navigation Menus To Exist
  use_waiter(),
  tags$body(
    HTML('<nav  class="navbar navbar-expand-md navbar-dark bg-dark fixed-top">
  <a class="navbar-brand" href="javascript:setPage(\'landing\')">ShinyMeNot</a>
  <button class="navbar-toggler" 
  type="button" data-toggle="collapse" 
  data-target="#navbarsExampleDefault" 
  aria-controls="navbarsExampleDefault" 
  aria-expanded="true" aria-label="Toggle navigation">
    <span class="navbar-toggler-icon"></span>
  </button>
  <div class="navbar-collapse collapse show" id="navbarsExampleDefault" style="">
    <ul class="navbar-nav mr-auto">
      <li class="nav-item active">
        <a class="nav-link" href="javascript:setPage(\'landing\')";>Home <span class="sr-only">(current)</span></a>
      </li>
      
      <li class="nav-item">
        <a class="nav-link" href="javascript:setPage(\'home\')">About</a>
      </li>
      
    
      <li class="nav-item dropdown">
        <a class="nav-link dropdown-toggle" id="dropdown01" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">Reporting</a>
        <div class="dropdown-menu" aria-labelledby="dropdown01">
          <a class="dropdown-item" href="javascript:setPage(\'reports_echarts\');">Echarts action</a>
          <a class="dropdown-item" href="#">Something else here</a>
        </div>
      </li>
      
    </ul>
  </div>
</nav>'),
#   
#   HTML('<nav class="navbar navbar-default navbar-static-top" role="navigation">
#   <div class="container-fluid">
#     <div class="navbar-header">
#       <span class="navbar-brand">App Title</span>
#     </div>
#     <ul class="nav navbar-nav" data-tabsetid="8166">
#       <li class="active">
#         <a href="javascript:setPage(\'admin_dataPreview\');" >Admin Data</a>
#       </li>
#       <li>
#         <a href="#tab-8166-2" data-toggle="tab" data-value="Summary">Summary</a>
#       </li>
#       <li>
#         <a href="#tab-8166-3" data-toggle="tab" data-value="Table">Table</a>
#       </li>
#     </ul>
#   </div>
# </nav>
# <div class="container-fluid">
#   <div class="tab-content" data-tabsetid="8166">
#     <div class="tab-pane active" data-value="Plot" id="tab-8166-1"></div>
#     <div class="tab-pane" data-value="Summary" id="tab-8166-2"></div>
#     <div class="tab-pane" data-value="Table" id="tab-8166-3"></div>
#   </div>
# </div>
# </div>'
# ),
    # customNav("home",
    #           "reports",
    #           "analytics",
    #           "admin",
    #           "profile"
    # ),
    
    shinyjs::useShinyjs(debug = FALSE),
    # This determines what page is being used
    hidden(selectInput("pageID", label = "",choices = c(), selected = "")),
    # For Any Modules that simply display a markdown file.
    hidden(selectInput("moduleFile", label = "",choices = c(), selected = NULL)),
    # Main Output That Is Then Switched Between
    # Maybe something to change the style of this for some modules
    withSpinner(div(id = "mainOutput", class = "shiny-html-output",
        style = 'margin-top:60px;background-color:#ccc;'),type = 8,color = "darkblue"
    ),
tags$div(
HTML('<footer class="footer dark mt-auto py-3">
  <div class="container">
    <span class="text-muted">Place sticky footer content here.</span>
  </div>
</footer>')
)
    
  ),
  # Loading Page
  waiter_show_on_load(html = spin_fading_circles())
)

# Define server logic required to draw a histogram
server <- function(input, output,session) {
  
  session$userData[['id']] <- stringr::str_to_lower(Sys.getenv("USER"))
  session$userData[['con']]  <- AppConfig$make_con(RSQLite::SQLite(),cfg$sql_lite_con, NULL, NULL)
  
  refresh_con <- function(con=NULL){
    if (is.null(con)){
      con <- AppConfig$make_con(RSQLite::SQLite(),cfg$sql_lite_con, NULL, NULL)
    }
    else if (!dbIsValid(con)){
      con <- AppConfig$make_con(RSQLite::SQLite(),cfg$sql_lite_con, NULL, NULL)
    } 
    return(con)
  }
  con <- refresh_con()
  AppUser <- User$new(name = str_to_lower(Sys.getenv('USER')))
  AppUser$set_role(con) # Sets the role of the AppUserObject
  # Home Page
  output$home <- renderUI({
    #<span class="fa fa-home"></span>
    moduleNav(id = "navDropdown1",label = "",moduleName = "home",
              icon("home"))
  })
  rt_home <- callModule(home,id="home")
  # After home is loaded hide the waiter
  waiter_hide()
  
  # Module Access - Only shows if user has permission
  if (AppUser$view_role() %in% c("admin","free","user")){
    output$reports <- renderUI({
      navDropdown(id = "navDropdown2",label = "Reports",
                  moduleDropdownLink("Case Studies","reports_caseStudies"),
                  moduleDropdownLink("Dashboard","reports_echarts")
      )
    })
    rt_caseStudies <- callModule(reports_caseStudies,id = "reports_caseStudies")
    rt_echarts <- callModule(reports_echarts,id = "reports_echarts")
  }
  
  #Admin For Everyone for now
  if (AppUser$view_role() %in% c("admin","free","user")) {
    output$admin <- renderUI({
      navDropdown(id = "navDropdownAdmin",label = "Admin",
                  moduleDropdownLink("Datatables","admin_dataPreview")
      )
    })
    rt_dataPreview <- callModule(admin_dataPreview, id = "admin_dataPreview")
  }
  
  # output$normal <- renderUI({
  #   navbarMenu("More",
  #              tabPanel("Summary"),
  #              "----",
  #              "Section header",
  #              tabPanel("Table")
  #              
  #              
  #   )
  # })
  
  page <- reactive({ input$pageID })
  parm1 <- reactive({ input$app_parm1 })
  # Watch for parms to be changed and set in user data
  observe({
    session$userData$parm1 <- parm1()
  })
  
  # Shiny Book Marking
  # Use Shiny To Book Mark the page 
  # As opposed to javascript.
  # Where do user params get stored if bookmarked
  
  output$mainOutput <- renderUI({
    if (page() != '') {
      Sys.sleep(.25)
      ui <- do.call(paste0(page(),"UI"), list(page()))
      #Sys.sleep(.25)
    } else {
      runjs("setPage('home');")
      #Sys.sleep(.25)
      #do.call(paste0("home","UI"), list("home"))
    }
  })
  
  onStop(function() {
    cat("Application stopped\n")
  })
  
  onSessionEnded(function() {
    cat("Session stopped\n")
  })
}
#odbc::odbcListDrivers()
#mongodb+srv://shiny-template:<password>@rshiny-zstp9.mongodb.net/<dbname>?retryWrites=true&w=majority
# con <- DBI::dbConnect(
#   odbc::odbc(),
#   Driver        = "MongoDB ANSI ODBC",
#   Server        = "mongodb+srv://shiny-template",
#   Port          = 27015,
#   Database      = "sample_airbnb",
#   AuthMechanism = "SCRAM-SHA-1", # <- Example, depends server's auth setup
#   UID           = "shiny-template",
#   PWD           = 
#     #rstudioapi::askForPassword("Database password")
# )
#mongodb+srv://shiny-template:<password>@rshiny-zstp9.mongodb.net
#Run the application 
shinyApp(ui = ui, server = server)


