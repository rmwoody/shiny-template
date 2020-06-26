admin_dataPreviewUI <- function(id){
  ns = NS(id)
  tagList(br(),
          div(class ="container-fluid", style = 'padding:35px;align-content:center;',
                div(class = "card" ,style = "padding:37px;",
                            h3("S3 Buckets"),
                            uiOutput(ns("s3_buckets")),height = 300),
              dashboardCard(id = ns("value1"),
                            sparklineOutput(ns("value1spark"))),
              excelOutput(ns("exltable"),width = "100%"),
              column(8, dashboardCard(id = NULL,
                                      h5("Tables"),
                                         DT::dataTableOutput(ns("tables"))
                                      )
              
              ),
              column(8, 
                     dashboardCard(id = NULL,
                                   h5("User Roles"),DT::dataTableOutput(ns("users"))
                                   
                     )
              ),
              HTML('<div class="card">
<div class="card-body">
<div class="stat-widget-four">
<div class="stat-icon dib">
<i class="ti-server text-muted"></i>
</div>
<div class="stat-content">
<div class="text-left dib">
<div class="stat-heading">Database</div>
<div class="stat-text">Total: 765</div>
</div>
</div>
</div>
</div>
</div>')
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
