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
                    // It is likely jsonld. Draw graph using jsonldVis
                    jsonldVis(d3);
                    jsonldVis(data, "#"+ele_id, { w: 800, h: 600, maxLabelWidth: 250 });
                } else {
                    // Preview json using JSON formatter. It is expanded to just one level deep.
                    // If we desire deeper levels to be expanded, for example, 3, it is
                    // const formatter = new JSONFormatter(data, 3);
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
