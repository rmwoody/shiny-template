# The config class is a class for handling both secure and non secure config info
# Right now, there are no methods for decryption, and the only database being used
# is a sql lite database with no password. However, this shows how a Config class
# can be set up to initialize for an app. For instance, it could fetch environment variables
# or use some more complex logic. 
Config <- R6Class("Config", 
                  public = list(
                    config = NULL,
                    secure_vars = NULL,
                    initialize = function(config,secure_config) {
                      self$config <- config
                      private$secure_config = secure_config
                      self$secure_vars = names(secure_config)
                      
                    },  
                    make_con = function(dbtype,dbname,dbusername,dbpassword){
                      stopifnot(dbname %in% self$config)
                      # Stop if not using a dbname from the config file
                      # Stop if not using a dbpassword/username registered to this class
                      stopifnot(dbusername %in% private$secure_config | is.null(dbusername))
                      stopifnot(dbpassword %in% private$secure_config | is.null(dbpassword))
                      if (!dbCanConnect(dbtype,dbname,dbusername,dbpassword)){
                        stop("Check username or password")
                      } else {
                        return(dbConnect(dbtype,dbname,dbusername,dbpassword))
                      }
                    },
                    active = list(
                      con = function(value) {
                        if (missing(value)) {
                          dbConnect(self$config[[value]])
                        } else {
                          stop("Must Pass A Connection String", call. = FALSE)
                        }
                      }
                    ),
                    
                    print = function(...) {
                      cat("  Config: ", paste(names(x),x, sep = ": "), sep = "\n")
                      cat("  Secure Config: ", paste(names(x), sep = ": "), sep = "\n")
                    }
                  ),
                  private = list(
                    secure_config = NULL
                  )
)


# Demo for how to use.
if (FALSE){
  AppConfig <- Config$new(cfg, secure_config = NULL)
  userCon <- AppConfig$make_con(RSQLite::SQLite(),cfg$sql_lite_con, NULL, NULL)
  AppConfig
}













