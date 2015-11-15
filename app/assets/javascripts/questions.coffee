$ ->
  $('.question').on 'click', 'a.edit-question-link', (e) ->
    e.preventDefault()
    alert('gogo')
    $(this).hide()
    $('div#edit-question-form-container').show()
    return

$ ->
  $('.answers').on 'click', 'a.edit-answer-link', (e) ->
    e.preventDefault()
    answer_id = $(this).data('answer-id')
    $(this).hide()
    $('form#edit_answer_' + answer_id).show()
    return