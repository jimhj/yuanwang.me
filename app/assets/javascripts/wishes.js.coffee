# = require jquery-fileupload/vendor/jquery.ui.widget
# = require jquery-fileupload/jquery.iframe-transport
# = require jquery-fileupload/jquery.fileupload
$(document).ready ->
  $('#fileupload').fileupload({
    dataType: 'json',
    url: "/wishes/upload",
    add: (e, data) ->
      $('span.loading').show()
      data.submit()
    done: (e, data) ->
      $('span.loading').hide()
      preview = data.result.preview
      photo = data.result.photo

      $('#fileupload').parents('.btn').after("<img src='#{preview}' />")
      $('#wish_photo').val photo

  })