Blacklight.onLoad(function() {
    function showFile(evt, file_id) {
      // Declare all variables
      var i, tabcontent, tablinks;

      // Get all elements with class="vertical-tab-content" and hide them
      tabcontent = document.getElementsByClassName("vertical-tab-content");
      for (i = 0; i < tabcontent.length; i++) {
        tabcontent[i].style.display = "none";
      }

      // Get all elements with class="tablinks" and remove the class "active"
      tablinks = document.getElementsByClassName("vertical-tab-links");
      for (i = 0; i < tablinks.length; i++) {
        tablinks[i].className = tablinks[i].className.replace(" active", "");
      }

      // Show the current tab, and add an "active" class to the link that opened the tab
      document.getElementById(file_id).style.display = "block";
      evt.currentTarget.className += " active";
    }
} );