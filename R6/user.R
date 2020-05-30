
# Define an R6 object. 
User <- R6Class("User", 
                  public = list(
                    userData = list(),
                    set_role = function(con){
                     stopifnot(dbIsValid(con))
                      role <- dbGetQuery(con, 'SELECT role from USER_ROLES where USERNAME  = :x', 
                                         params = list(x = private$name))
                      if(nrow(role)==0){
                        role = "free"
                      }
                      private$role <- role
                      return(invisible(self))
                    },
                    view_role = function(){
                      return(paste(private$role))
                    },
                    initialize = function(name) {
                      private$name <- name
                    },
                    print = function(...) {
                      cat("Person: \n")
                      cat("  Name: ", private$name, "\n", sep = "")
                      cat("  Role:  ", private$role, "\n", sep = "")
                    }
                  ),
                  private = list(
                    name = NULL,
                    role = NULL
                  )
)



