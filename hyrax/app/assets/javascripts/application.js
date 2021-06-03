// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require dataTables/jquery.dataTables
//= require dataTables/bootstrap/3/jquery.dataTables.bootstrap
//= require bootstrap-datepicker
//
// Required by Blacklight
//= require blacklight/blacklight
//= require csv_preview

//= require_tree .
//= require hyrax


// Patch hyrax form submit to keep the submit button values
// so that they get to Rails even when they are disabled
Blacklight.onLoad(function() {
  $("form[data-behavior='work-form'] input[type=submit]").click(function (e) {
    var button = $(this);
    var form = button.parents('form')[0]
    $(form).append(`<input type="hidden" id="${this.id}-hidden" name="${this.name}" value="${this.value}"></input>`)
  });
  // Remove comment radio option in workflow
  if ($("#workflow_action_name_comment_only").length == 1) {
  	var parent_ele = $("#workflow_action_name_comment_only").closest('div.radio');
  	var sibling_ele = parent_ele.prev();
  	parent_ele.hide();
  	sibling_ele.find('input[type=radio]').first().prop('checked', 'checked');
  }
})
