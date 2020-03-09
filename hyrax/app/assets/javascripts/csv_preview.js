$( document ).on('turbolinks:load', function() {
    $('.csv-preview').each(function() {
        var preview = $(this);
        $.ajax({
            url: preview.data('url'),
            success: function (data) {
                preview.find('.csv-preview-error').hide();
                preview.find('.csv-preview-datatable').DataTable({
                    data: data.data,
                    columns: data.columns.map(function (name) {
                        if (name === null) {
                            return { title: '' };
                        } else {
                            return {title: name.replace(/[\_\-]/g, ' ')};
                        }
                    }),
                    order: []
                });
                preview.find('.csv-preview-title').text('Preview: ' + data.file_name);
                if (data.total_rows > data.maximum_rows) {
                    preview.find('.csv-preview-size').text('preview is limited to the first ' + data.maximum_rows + ' records, the full file contains ' + data.total_rows + ' records').show();
                } else {
                    preview.find('.csv-preview-size').hide();
                }
            },
            error: function() {
                preview.find('.csv-preview-error').show();
            }
        });
    });
} );
