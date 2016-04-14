App.Banners =
  
  update_banner: (selector, text) ->
    $(selector).html(text)

  initialize: ->
    $('[data-js-banner-title]').on 
      change: ->
        App.Banners.update_banner("#js-banner-title", $(this).val())

    $('[data-js-banner-text]').on
      change: ->
        App.Banners.update_banner("#js-banner-text", $(this).val())

    $("#banner_style").each ->
      $this = $(this)
      callback_style = ->  
        new_class = "panel ".concat($this.val().split('.')[1], " margin-bottom")
        old_class = $("#js-banner-style").attr("class")
        console.log "old_class"+old_class
        console.log "new_class"+new_class 
        $("#js-banner-style").removeClass(old_class, true)
                             .addClass(new_class, true)
      $this.on 'change', callback_style