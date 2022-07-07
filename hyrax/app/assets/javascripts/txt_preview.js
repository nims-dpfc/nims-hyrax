Blacklight.onLoad(function() {
    $('.txt-preview').each(function() {
        var preview = $(this);
        if(preview.hasClass('done')) {
            return true
        }
        $.ajax({
            url: preview.data('url'),
            success: function (data) {
                preview.find('.txt-preview-error').hide();
                let ele_id = preview.data("ele");
                let ele = document.getElementById(ele_id);
                console.log(ele_id);
                // console.log(data['content']);
                ele.append(data['content']);
                preview.addClass('done')
            },
            error: function() {
                preview.find('.txt-preview-error').show();
            }
        });
    });
} );
