Blacklight.onLoad(function() {
  $(function() {
    $("div.vertical-tab-menu>div.list-group>a").click(function (e) {
      e.preventDefault();
      $(this).siblings('a.active').removeClass("active");
      $("div.vertical-tab>div.vertical-tab-content").removeClass("active");
      $(this).addClass("active");
      var ele_id = $(this).attr("href");
      $(ele_id).addClass("active");
    });
  });
});

Blacklight.onLoad(function() {
  $(function() {
    $(".preview_file_types").click(function(e) {
      // e.preventDefault();
      var ele_id = $(this).attr("href");
      var ele = $(ele_id);
      var active_inner_tab = ele.find(".list-group-item.active");
      if(active_inner_tab.length === 1) {
        $(active_inner_tab[0]).trigger('click');
      } else {
        var inner_tab = ele.find(".list-group-item:first");
        if(inner_tab.length === 1) {
          $(inner_tab[0]).trigger('click');
        }
      }
    });
  });
});
