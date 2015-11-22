$ ->
  $('.question').on 'click', 'a.edit-question-link', (e) ->
    e.preventDefault()
    $(this).hide()
    $('div#edit-question-form-container').show()

  $('.answers').on 'click', 'a.edit-answer-link', (e) ->
    e.preventDefault()
    answer_id = $(this).data('answer-id')
    $(this).hide()
    $('form#edit_answer_' + answer_id).show()

  $('.question .vote-plus, .question .vote-minus').bind 'ajax:success', (e, data, status, xhr) ->
    response = $.parseJSON(xhr.responseText)
    $('p.votes-sum').text(response.votes_sum)
    $('.question .votes-container').html(response._html)

  $('.answers .vote-plus, .answers .vote-minus').bind 'ajax:success', (e, data, status, xhr) ->
    response = $.parseJSON(xhr.responseText)
    $('#answer_' + response.voted_to_id + ' .votes p.votes-sum').text(response.votes_sum)
    $('#answer_' + response.voted_to_id + ' .votes-container').html(response._html)
