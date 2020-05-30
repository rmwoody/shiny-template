function setPage(page) {
  console.log("JD::Shiny setPage -> "+page);
  $("#pageID").val(page).change();
  Shiny.setInputValue("pageID", page); // report the change to shiny
  $("li.nav-item").each(function() {
    if ($(this).html().match(page) && (!$(this).html().match('home-icon'))) {
      $(this).addClass('active');
    } else {
      $(this).removeClass('active');
    }
  });
  $("a.nav-link").each(function() {
    if ($(this).attr('href').match(page)) {
      $(this).addClass('active');
    } else {
      $(this).removeClass('active');
    }
  });   
  setUrlParameter('page',page);
}


function toggle_id(id) {
  $("#"+id).toggle();  
}

function getUrlParameter(name) {
  var results = new RegExp('[\\?&]' + name + '=([^&#]*)').exec(window.location.href);
  if (results === null) { return 0; }
  return results[1] || 0;
}



function setUrlParameter(name,value) {
  var newURL = "";
  if (getUrlParameter(name) === 0) {
    if (window.location.href.includes("?")) {
      newURL = window.location.href + "&"+name+"=" + value;
    } else {
      newURL = window.location.href + "?"+name+"=" + value;
    }
  }else {
    newURL = window.location.href.replace(name+"="+getUrlParameter(name), name+"="+value);
  }
  window.history.replaceState('', '', newURL);
}



// JQuery needed to make tabs work

$(document).on('click', "a.nav-link", function() {
  href = $(this).attr('href'); // tab content
    var hash = href.substring(href.indexOf('#')); // '#foo'
    $('.tab-content').children('div').each(function () {
      // div(class="tab-pane active show", id="module-tab-content", `role`="tabpanel", `aria-labelledby`="module-tab",
             if ("#"+$(this).attr('id') == hash || "#"+$(this).attr('id') == href) {
               $(this).addClass('active');
               $(this).addClass('show');
             } else {
               
               $(this).removeClass('active');
               $(this).removeClass('show');
             }
    });
});
    
    
$( document ).ready(function() {
      
      // Need to change all container-fluid classes to nothing
      
$('.container-fluid').removeClass('container-fluid');
      console.log("Modular::Shiny Document ready");
});

  