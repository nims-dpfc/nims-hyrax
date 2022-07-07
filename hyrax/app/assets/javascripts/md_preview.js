Blacklight.onLoad(function() {
    $('.md-preview').each(function() {
        var preview = $(this);
        if(preview.hasClass('done')) {
            return true
        }
        $.ajax({
            url: preview.data('url'),
            success: function (data) {
                preview.find('.md-preview-error').hide();
                let ele_id = preview.data("ele");
                let ele = document.getElementById(ele_id);
                ele.innerHTML = data['content'];
                preview.addClass('done')
            },
            error: function() {
                preview.find('.md-preview-error').show();
            }
        });
    });
} );
