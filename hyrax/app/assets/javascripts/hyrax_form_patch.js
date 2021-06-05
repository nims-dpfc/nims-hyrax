// Patch hyrax form submit to keep the submit button values
// so that they get to Rails even when they are disabled
Blacklight.onLoad(function() {
    console.log("Loading draft save file method");
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