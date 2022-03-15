Blacklight.onLoad(function() {
    $('.json-preview').each(function() {
        var preview = $(this);
        if(preview.hasClass('done')) {
            return true
        }
        $.ajax({
            url: preview.data('url'),
            success: function (data) {
                preview.find('.json-preview-error').hide();
                let ele_id = preview.data("ele");
                let ele = document.getElementById(ele_id);
                if('@context' in data){
                    jsonldVis(d3);
                    jsonldVis(data, "#"+ele_id, { w: 800, h: 600, maxLabelWidth: 250 });
                    ele.scrollLeft = ele.scrollWidth;
                } else {
                    const formatter = new JSONFormatter(data);
                    ele.appendChild(formatter.render());
                }
                preview.addClass('done')
            },
            error: function() {
                preview.find('.json-preview-error').show();
            }
        });
    });
} );
