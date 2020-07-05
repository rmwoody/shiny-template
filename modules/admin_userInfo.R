admin_userInfoUI <- function(id){
  ns = NS(id)
  ui <- fluidPage(
    verbatimTextOutput(ns("user_info")),
    verbatimTextOutput(ns("credential_info")),
  )
  
}

admin_userInfo <- function(input, output, session){
  ns = session$ns
  # print user info
  output$user_info <- renderPrint({
    session$userData$auth0_info
  })
  
  output$credential_info <- renderPrint({
    session$userData$auth0_credentials
  })
  
}



