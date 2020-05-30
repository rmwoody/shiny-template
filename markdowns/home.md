# Shiny Me Not
This app is a framework to display some of the cool functionality that can be achieved through shiny customization, allowing for the easy creation of entire websites from a shiny app. The app relies on a modular framework and a "mainPage" that gets replaced when a module is called. This makes code scalable and allows multiple developers to work on the same app. A summary of some of this functionality is given below.

#### Premise
The premise of this template is that you are at a point that no boiler plate shiny solution meets the needs of your application. It is assumed that some tinkering with css and javascript will take place. This template is designed bare bones to allow more detailed customization without constantly having to override default styling present in shiny app packages.


## Modular Design
Shiny modules have a UI and a Server Component. The layout of this app treats every tab as a separate module to be sourced and uses a single ui page to render this content. This way, the app does not actually need to worry about the HTML components until a specific module is displayed. There are other ways to modularize code, including R6 classes, however, this method is very flexible and requires very few changes to the main `app.R` file even as dozens of modules are added. 


#### Customization
The modular design makes it easy to customize the app to serve multiple types of users. This design leverages the dropdown menus as the primary dynamic content. Only the menus that are relevant to a user are displayed after they log in. Depending on how the app is deployed, user roles may need to be queried from a database or parsed from information transmitted via some other authorization service.


#### Markdown Files
`Markdown` files are a great way to document content in apps and can be stored in a separate folder to be rendered on comand. While the same can be done with `HTML` files, you have to be careful that these files include only body elements, otherwise they will conflict with the existing css. 


#### User Roles
User roles determine the dropdown menus that are availible for a user. Roles can either be retrived through pass through after authentication, or may come from another database.
This approach makes it possible to merge functionality of many apps into one without impeding development.


#### Bookmarking
Bookmarking allows both the module and any important inputs to be recorded. Bookmarked inputs can be stored in a database using a timestamp usernames and modules, either as a key in the database or a key in the json. Loading this data can occur either on module load or the app load for the user.


## App Versioning
One issue that shiny does not deal with by default is app versioning. App versions can be important for functions that log data or retrieve data. If the structure of this data changes with versions, new tables may need to be created in app databases. In general, any tables that the app needs to function which are not controlled externally should be checked with each update to the app. A major change is defined as a change in the first number of app versions, for instance version `1.x.x` to version `2.x.x`.


## Code Styling
This template includes styling for several code languages and uses the  `highlight.js` themes. It makes sharing technical case stuides easy and appealing to the eyes. This version uses the atom-one-dark theme, but there are dozens of others to choose from.

###### Python
```{python}
def printUserInfo(username):
  age = 1
  name = "Name"
  return({username:{age:1,name:"Name"}})
```

###### R
```r
printUserInfo <- function(username){
  age <- 1
  name <- "Name"
  rv <- list(username = list(age = 1,name = "Name"))
  return{rv)
}
```


