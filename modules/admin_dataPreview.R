admin_dataPreviewUI <- function(id){
  ns = NS(id)
  tagList(br(),
          div(class ="container-fluid", style = 'padding:35px;align-content:center;',
             column(12, dashboardCard(id = NULL,
                  h5("S3 Buckets"),
                  hr(),
                  uiOutput(ns("s3_buckets")),height = 300)),
              column(12, dashboardCard(id = NULL,
                                      h5("Tables"),
                                      hr(),
                                      DT::dataTableOutput(ns("tables"))
              )
              
              ),
              column(12, 
                     dashboardCard(id = NULL,
                                   h5("User Roles"),
                                   hr(),
                                   DT::dataTableOutput(ns("users"))
                                   
                     )
              ),
              excelOutput(ns("exltable"),width = "100%"),
          )
  )
  
  
  
}

admin_dataPreview <- function(input, output, session){
  
  ns = session$ns
  con <- session$userData[['con']]
  s3 <- paws::s3()
  
  
  buckets <- reactive({
    df <- lapply(s3$list_buckets(),function(x){bind_rows(x)}) %>% bind_rows()
    df
  })
  
  output$tables <- renderDataTable({
    dbListTables(con)
    tables <- data.frame(tableName = dbListTables(con))
    listFields <- function(conn,x){
      fields <- dbListFields(con,x)
      paste(paste(dbListFields(con,x,collapse = ";")),collapse = ";")
    }
    tables$fields <-mapply(listFields,conn=list(con),as.character(tables$tableName))
    DT::datatable(tables)
  })
  
  output$s3_buckets <- renderUI({
    div(renderDT(buckets()))
  })
  
  
  
  
  
  output$users <- renderDataTable({
    users = dbGetQuery(con,"SELECT * FROM USER_ROLES")
    DT::datatable(users)
  })
  
  output$exltable <-renderExcel(excelTable(data = head(iris)))
  
}


