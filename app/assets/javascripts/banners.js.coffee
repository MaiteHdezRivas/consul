App.Banners =

  initialize: ->
    $('[data-js-banner-title]').each ->
      $this = $(this)
      console.log "Título: ", $this.val() 
      callback = ->
        $("#js-banner-title").html($this.val())
      $this.on 'change', callback

    $('[data-js-banner-text]').each ->
      $this = $(this)
      console.log "Text: ", $this.val() 
      callback_text = ->
        $("#js-banner-text").html($this.val())
      $this.on 'change', callback_text

    $("#banner_style").each ->
      $this = $(this)

      callback_style = ->  
        new_class = "panel ".concat($this.val().split('.')[1], " margin-bottom")
        old_class = $("#js-banner-style").attr("class")
        $("#js-banner-style").removeClass(old_class, true)
        $("#js-banner-style").addClass(new_class, true)
      $this.on 'change', callback_style
