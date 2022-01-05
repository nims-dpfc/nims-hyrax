Blacklight.onLoad(function() {
    let agreementCheckbox = $("#supervisor_agreement");
    let main_submit_button = $('#with_files_submit');
    if (agreementCheckbox.length === 1) {
        if (!agreementCheckbox.prop('checked')) {
            main_submit_button.attr("disabled", true);
            $('#required-supervisor-agreement').removeClass( "complete" ).addClass( "incomplete" );
        } else {
            $('#required-supervisor-agreement').removeClass( "incomplete" ).addClass( "complete" );
        }
    }
    agreementCheckbox.click(function (e) {
        if (agreementCheckbox.prop('checked')) {
            $('#required-supervisor-agreement').removeClass( "incomplete" ).addClass( "complete" );
            if ($('.requirements > .incomplete').length <= 0) {
                main_submit_button.attr('disabled', false);
            }
        } else {
            $('#required-supervisor-agreement').removeClass( "complete" ).addClass( "incomplete" );
            main_submit_button.attr('disabled', true);
        }
    });
    main_submit_button.change(function() {
        // This is not called, as change event is not triggered
        if (main_submit_button.prop('disabled', false) && agreementCheckbox.length === 1 && !agreementCheckbox.prop('checked')) {
            main_submit_button.attr("disabled", true);
        }
    });
});


