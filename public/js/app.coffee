$(document).ready ->
  $('textarea').autosize()
  $('#create-stash').click ->
    tags = $('input[name="create_tags"]').val()
    content = $('textarea[name="create_text"]').val()
    $.ajax '/stash',
      type: 'json',
      method: 'post',
      data: {tags: tags, content: content},
      success: (data) ->
        alert(data)
  $('#get-stash').click ->
    tags = $('input[name="get_tags"]').val()
    $.ajax '/stash',
      type: 'json',
      method: 'get',
      data: {tags: tags},
      success: (data) ->
        parsed = JSON.parse(data)
        if $('.response').length > 0
          $('.response').text(parsed.result)
        alert(data)
  $('#delete-stash').click ->
    tags = $('input[name="delete_tags"]').val()
    $.ajax '/stash',
      type: 'json',
      method: 'delete',
      data: {tags: tags},
      success: (data) ->
        alert(data)