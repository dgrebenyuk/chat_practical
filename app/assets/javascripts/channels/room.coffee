App.room = App.cable.subscriptions.create "RoomChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # alert(data['message'])
    $('#messages').append data["message"]
    # Called when there's incoming data on the websocket for this channel

  speak: (message) ->
    @perform 'speak', message: message

  send_msg = ->
    App.room.speak $('#message_field').val()
    $('#message_field').val('')

  $(document).on 'keypress', '[data-behavior~=room_speaker]', (event) ->
    if event.keyCode is 13 # return/enter = send
      send_msg()
      event.preventDefault()

  $(document).on 'click', '[id~=send_btn]', (event) ->
    send_msg()
