
Password <- R6Class("Password",
                    list(
                      print = function(...) {
                        cat("<Password>: ********\n")
                        invisible(self)
                      },
                      set = function(value) {
                        private$password <- value
                      },
                      check = function(password) {
                        identical(password, private$password)
                      }
                    ),
                    list(
                      password = NULL
                    )
)