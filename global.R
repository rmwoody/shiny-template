#################################################################
"The global.R file should contain anything that needs to be shared
for all users/ read in at the start of the app. If your app uses
an global database connections, this would be the place to include
them. This is also where logic to include a specific config setting
should be included."
#################################################################
source("general/setup.R")
packages <- all.packages("global.R") # Something for the version
# When pushing to shinyapps.io, it seems you need library in the code
library(dplyr)
library(shinyWidgets)
library(shinydashboard)
library(shinydashboardPlus)
library(rmarkdown)
library(waiter)
library(config)
library(shinyjs)
library(import)
library(dbConnect)
library(DBI)
library(R6)
library(stringr)
library(echarts4r)
library(glue)
library(tidyr)
library(dplyr)
library(glue)
library(DT)

install_list <- new.packages(packages)
if (Sys.getenv("R_CONFIG_ACTIVE")=="local"){install.new.packages(install_list)} # Skip For Deployment

source("R6/bivariatePlot.R")
source("R6/password.R")
source("R6/config.R")
source("R6/user.R")
source("ui_elements/components.R")
source("ui_elements/card.R")
source("R6/database_prep.R")
#import::here(User, .from = "R6-Components.R")


#########################################################################
"Connections should generally be made for each user/session. For one,
there is no way to log activity, such as calls to a database, beyond 
knowning the application is accessing, unless some logging steps are taken.
Connections should always be disconnected on session end."
#########################################################################

if (Sys.getenv("R_CONFIG_ACTIVE") == "RSCONNECT"){# This needs to be made correct
  active_config = 'rsconnect'
}else{active_config = 'default' }
#Sys.getenv("R_CONFIG_ACTIVE") == "RSCONNECT"
cfg <- config::get(file = "config/config.yml",config = active_config )
secure_config <- config::get(file = "config/secure_config.yml",config = active_config)

# In memomry Database,
#role_con <- dbConnect(RSQLite::SQLite(), ":memory:")
# Create a database initially
# Normally this would be done outside of the app
# db <- dbConnect(RSQLite::SQLite(), "data/app_db.sqlite")
# unlink("/data/app_db.sqlite")

# Some useful links
#https://stackoverflow.com/questions/46693161/wrapping-shiny-modules-in-r6-classes
#http://www.chenghaozhu.net/posts/en/2019-03-25/

# For now, there is no use for the secure config, but that can change.
AppConfig <- Config$new(cfg, secure_config = NULL)
AppConfig$config$app_version
con <- AppConfig$make_con(RSQLite::SQLite(),cfg$sql_lite_con, NULL, NULL)

# A User Role Table - this is not "ideal" but for demonstration
initial_user <- data.frame(USERNAME = c('adminAccount'), ROLE = c('admin'))
try({dbWriteTable(con,"USER_ROLES",initial_user)},silent = TRUE)
# For demo, this should be a SQL script usually
dbExecute(con,glue("
INSERT INTO USER_ROLES (USERNAME, ROLE)
SELECT * FROM (SELECT '{Sys.getenv('USER')}', 'admin') AS tmp
WHERE NOT EXISTS (
    SELECT USERNAME FROM USER_ROLES WHERE USERNAME = 'robertwoody'
) LIMIT 1; ") %>% as.character())

# Any Tables That Are Versioned By The App.
# User Inputs would probably be more common.
# Here, a table for inputs from home page
DBprep <- DatabasePrep$new(version = cfg$app_version)
DBprep$prepare_table(con,"sql/logins.sql","HOME_PAGE") # for logging home page inputs

#################################################################
"Source Modules From the Module Folder"
#################################################################
for (m in list.files("./modules/")){
  source(paste0("./modules/",m))
}

#################################################################
"Once all modules are sourced, there are a couple approaches to
using them. The first is to simply include them in the app 
with rt_{module} = callModule(). This method requires explicit if 
else statements in the app.R file to determine if the navbar and
server/ui parts of the module should be called. A second but
experimental way is to set an R6 class to have UI and Server
components that are the server/UI in question. These R6 classes
also have separate UI/server components to manage Navbar Display 
and are then called in the app.R file."
#################################################################


# Any R6 Modules that should be availible everywhere.
# For instance, a password module or user info module
xy_mtcars <- bivariateClass$new(data = mtcars)
dbDisconnect(con)

