window.onload = ->
  console.log "Subscribing to " + location.host + "/faye"
  window.packratClient = client = new Faye.Client(location.origin + "/faye",
    timeout: 30
  )
  client.disable "autodisconnect"
  client.subscribe "/packrat", (message) ->
    console.log "packrat incoming"
    console.log message
    if message.reload
      console.log "reloading..."
      location.reload()
    else
      document.getElementById("packrat-css").innerHTML = message.css