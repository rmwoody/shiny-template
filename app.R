#######################################################
"app.R is the user specific code that runs to create 
each session. User Roles are set and specific modules
are called"
#######################################################
source("global.R")
ui <- fluidPage(
  tags$head(
    # Custom CSS and JavaScript
    tags$script(src = "js/custom.js"),  
    tags$link(rel = "stylesheet", type = "text/css", href = "css/yeti.css"),
    tags$link(rel = "stylesheet", type = "text/css", href = "css/customyeti.css"),
    tags$link(rel="stylesheet",type = "text/css",
              href="highlight/styles/atom-one-dark.css"),
    tags$script(src="highlight/highlight.pack.js"),
    tags$script("hljs.initHighlightingOnLoad();"),
  ),
  #Shiny.setInputValue(id, value);
  #https://shiny.rstudio.com/articles/communicating-with-js.html
  tags$body(
    # The Possible Navigation Menus To Exist
    use_waiter(),
    customNav("home",
              "reports",
              "analytics",
              "admin",
              "profile"
    ),
    shinyjs::useShinyjs(debug = FALSE),
    # This determines what page is being used
    hidden(selectInput("pageID", label = "",choices = c(), selected = "")),
    # For Any Modules that simply display a markdown file.
    hidden(selectInput("moduleFile", label = "",choices = c(), selected = NULL)),
    # Main Output That Is Then Switched Between
    # Maybe something to change the style of this for some modules
    div(id = "mainOutput", class = "shiny-html-output",
        style = 'margin-top:60px;background-color:#ccc;'
        #theme = shinytheme("cerulean")
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
    moduleNav(id = "navDropdown1",label = "Home",moduleName = "home")
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
  
  # Admin 
  if (AppUser$view_role() == "admin"){
    output$admin <- renderUI({
      navDropdown(id = "navDropdownAdmin",label = "Admin",
                  moduleDropdownLink("Datatables","admin_dataPreview")
      )
    })
    rt_dataPreview <- callModule(admin_dataPreview, id = "admin_dataPreview")
  }
  
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
      ui <- do.call(paste0(page(),"UI"), list(page()))
    } else {
      runjs("setPage('home');")
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

# Run the application 
shinyApp(ui = ui, server = server)
