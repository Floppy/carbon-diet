
try {
  // If jquery is loaded this will run. 
  $(document).ready(function() {

    jQuery.ajaxSetup({
      "beforeSend": function(xhr)  {xhr.setRequestHeader("Accept", "text/javascript")}
    })

    $("#ie-no-more-close-button").click(function() {
  		$.ajax({
  			type: "POST",
  			url: '/ie_hide_messages',
  			complete: function() { $("#ie-no-more-container").hide();  }
  		});
  		return false;
    });
  
  });
}
catch(err) {
  // Must be prototype
}

try {
  // If Prototype, then this will happen...
  Event.observe(window, 'load', function() {
    Event.observe('ie-no-more-close-button', 'click', function(e){ 
      new Ajax.Request("/ie_hide_messages", {
           method:'post',
           onSuccess: function() {
             $("ie-no-more-container").hide();
           }
       });
   		return false;
     });
  });
}
catch(err) {
  // Must be jquery
}
