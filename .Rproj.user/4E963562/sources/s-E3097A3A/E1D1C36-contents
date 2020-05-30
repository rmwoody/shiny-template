library(readr)
DatabasePrep <- R6Class("DatabasePrep", 
                        public = list(
                          version = NULL,
                          tables = NULL,
                          initialize = function(version,tables) {
                            self$version = version
                            self$tables = list()
                          },
                          read_tbl_prep_sql = function(con,file,tbl_name){
                            statement <- read_file(file)
                            statement<- sqlInterpolate(con,statement, tbl_name = tbl_name)
                            return(statement)
                          },
                          get_table_versions = function(con,tbl_name){
                            tbl_name <- tbl_name
                            rexpr <- paste0(tbl_name,"_","\\d+")
                            cv <- as.integer(str_split(self$version,"\\.")[[1]][1]) # current version
                            tbls <- dbListTables(con) %>% str_extract(rexpr) # tbls
                            valid <- !is.na(tbls) # valid vector
                            tbls <- tbls[valid]
                            if (any(valid)){
                              db_v <- max(as.integer(str_extract(tbls,"[0-9]+")),na.rm =TRUE)
                              # Returns na if nothing has a number
                            } else{
                              db_v = NA
                            }
                            return(list(app_version = cv,
                                        database_version = db_v,
                                        tbls = tbls,
                                        valid = any(valid)
                            )
                            )
                          },
                          
                          prepare_table = function(con,file,tbl_name){
                            version_info <- self$get_table_versions(con,tbl_name)
                            sql_file <- file
                            # Version Info Valid Means That It Is A Versioned Table
                            if (version_info$valid){
                              paste("DB VERSION IS",version_info$database_version)
                              # If current app verision > than database version, create new table
                              if (version_info$app_version > version_info$database_version){
                                tbl_name <- paste0(tbl_name,"_",version_info$app_version)
                                sql <- self$read_tbl_prep_sql(con = con,
                                                         file = sql_file, 
                                                         tbl_name = tbl_name)
                                
                                dbExecute(con,sql)
                                if ((tbl_name) %in% dbListTables(con)){
                                  self$tables[[tbl_name]] <- "Updated Table"
                                }
                                print("CURRENT VERSION AHEAD OF DB VERSION: CREATING NEW VERSION")
                              }else{
                                self$tables[[tbl_name]] <- "Using Current Table"
                              }
                            } else {
                              print("TABLE DID NOT EXIST, CREATING NOW")
                              tbl_name <- paste0(tbl_name,"_",version_info$app_version)
                              sql <- self$read_tbl_prep_sql(con = con,
                                                       file = sql_file, 
                                                       tbl_name = tbl_name)
                              dbExecute(con,sql)
                              if ((tbl_name) %in% dbListTables(con)){
                                self$tables[[tbl_name]] <- "Created First Table"
                              }
                              #create table with current version
                            }
                            return(invisible(self))
                          }
                        )
)


if (FALSE){
  DBprep <- DatabasePrep$new(version = cfg$app_version)
  DBprep$get_table_versions(con,"LOGIN")
  sql_file <- "sql/logins.sql"
  DBprep$prepare_table(con,sql_file,"LOGINS")
}



