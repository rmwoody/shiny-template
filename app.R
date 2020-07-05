#######################################################
"app.R is the user specific code that runs to create
each session. User Roles are set and specific modules
are called"
#######################################################
source("global.R")
ui <- fluidPage(theme = "css/custom-bootstrap3.css",
                e_theme_register('{"color":["#440154FF,481B6DFF" ,"#46337EFF" ,"#3F4889FF",
                "#365C8DFF", "#2E6E8EFF", "#277F8EFF","#21908CFF" ,"#1FA187FF", "#2DB27DFF",
                "#4AC16DFF", "#71CF57FF", "#9FDA3AFF","#CFE11CFF",
"#FDE725FF"]}', name = "myTheme"),
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
                  custNavBar(custBrand(label = "ShinyMeNot",module_name = 'landing'),
                             uiOutput("home"),
                             uiOutput("landing"),
                             uiOutput("reports"),
                             uiOutput("case_studies"),
                             uiOutput('admin'),
                             logoutButton()
                             #custNav(id = "user_info")
                  ),
                  
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
                #waiter_show_on_load(html = spin_fading_circles())
)

#ui <- secure_app(ui,enable_admin = TRUE)
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
    custNav(id = "home",module_name = 'home')
  })
  
  rt_logins <- callModule(login,id = "login")
  rt_home <- callModule(home,id="home")
  
  waiter_hide()
  user_roles <- TRUE
  admin_tab <- TRUE
  report_tab <- TRUE
  case_tab <- TRUE
  home_tab <- TRUE
  landing_tab <- TRUE
  # Module Access - Only shows if user has permission
  if (report_tab){
    output$reports <- renderUI({
      navDropdown(id = "navDropdown3","Reports",
                    moduleDropdownLink(label = "Echarts",moduleName = "reports_echarts"))
    })
    rt_echarts <- callModule(reports_echarts,id = "reports_echarts")
  }
  
  
  if(case_tab){
    output$case_studies <- renderUI({
      custNav(id = "navDropdown1",label = "Case Studies",module_name = "reports_caseStudies")
    })
    rt_caseStudies <- callModule(reports_caseStudies,id = "reports_caseStudies")
  }
  
  if(home_tab){
    output$home <- renderUI({
      custNav(id = "navDropdown0",label = "About",module_name = "home")
    })
  }
  
  if (admin_tab) {
    output$admin <- renderUI({
      navDropdown(id = "navDropdownAdmin",label = "Admin",
                  moduleDropdownLink("Data Sources","admin_dataPreview"),
                  moduleDropdownLink("User Info","admin_userInfo"))
    })
    rt_dataPreview <- callModule(admin_dataPreview, id = "admin_dataPreview")
    rt_userInfro <- callModule(admin_userInfo,id = "admin_userInfo")
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
if (active_config == "shinyapps"){
  auth0::shinyAppAuth0(ui = ui, server = server)
}else{
  shinyApp(ui = ui, server = server)
}
