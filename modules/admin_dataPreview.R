admin_dataPreviewUI <- function(id){
  ns = NS(id)
  tagList(br(),
          div(class ="container-fluid", style = 'padding:35px;align-content:center;',
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
              )
          )
  )
  
}

admin_dataPreview <- function(input, output, session){
  ns = session$ns
  con <- session$userData[['con']]
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
  
  output$users <- renderDataTable({
    users = dbGetQuery(con,"SELECT * FROM USER_ROLES")
    DT::datatable(users)
  })
  
  output$exltable <-renderExcel(excelTable(data = head(iris)))
  
}
