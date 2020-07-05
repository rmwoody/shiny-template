#################################################################
"The global.R file should contain anything that needs to be shared
for all users/ read in at the start of the app. If your app uses
an global database connections, this would be the place to include
them. This is also where logic to include a specific config setting
should be included."
#################################################################
source("general/setup.R")
packages <- all.packages("global.R")
install_list <- new.packages(packages)
if (Sys.getenv("R_CONFIG_ACTIVE") %in% c("","local")){install.new.packages(install_list)} # Skip For Deployment
library(shiny)
library(shinyWidgets)
library(shinydashboard)
library(shinydashboardPlus)
library(stringr)
library(shinyjs)
library(sparkline)
library(shinycssloaders)
library(sodium)
library(rmarkdown)
library(R6)
library(waiter)
library(config)
library(import)
library(dbConnect)
library(DBI)
library(DT)
library(dplyr)
library(odbc)
library(echarts4r)
library(excelR)
library(glue)
library(tidyr)
library(paws)
library(pins)
library(auth0)

# May work on mac not windows/linux
# dynamo$put_item(
#   Item = list(
#     timestamp = list(
#       S = lubridate::now(tz = "UTC")
#     ),
#     username = list(
#       S = Sys.getenv("USER")
#     )
#   ),
#   ReturnConsumedCapacity = "TOTAL",
#   TableName = "logins"
# )
#dynamo$query()
# dynamo$get_item(
#   Key = list(
#     username = list(
#       S = "robertwoody"
#     )
#   ),
#   TableName = "logins"
# )
# dynamo$describe_table(TableName = "logins")

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

if (Sys.getenv("R_CONFIG_ACTIVE") == "shinyapps"){# This needs to be made correct
  active_config = 'shinyapps'
}else{active_config = 'default' }
#Sys.getenv("R_CONFIG_ACTIVE") == "RSCONNECT"
cfg <- config::get(file = "config/config.yml",config = active_config )
secure_config <- config::get(file = "config/secure_config.yml",config = active_config)
dynamo<- paws::dynamodb()
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
user <- Sys.getenv('USER')
sql <- sqlInterpolate(con,"
INSERT INTO USER_ROLES (USERNAME, ROLE)
SELECT * FROM (SELECT ?user, 'admin') AS tmp
WHERE NOT EXISTS (
    SELECT USERNAME FROM USER_ROLES WHERE USERNAME = 'robertwoody'
) LIMIT 1; ",user = user)
dbExecute(con,sql)

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



# environment(Myboard_initialize.s3) <- asNamespace('pins')
# assignInNamespace("board_initialize.s3", Myboard_initialize.s3, ns = "pins")

colors <- ('{"color":["#440154FF,481B6DFF" ,"#46337EFF" ,"#3F4889FF", "#365C8DFF", "#2E6E8EFF", "#277F8EFF",
"#21908CFF" ,"#1FA187FF", "#2DB27DFF", "#4AC16DFF", "#71CF57FF", "#9FDA3AFF","#CFE11CFF",
"#FDE725FF"]}')


dbDisconnect(con)

