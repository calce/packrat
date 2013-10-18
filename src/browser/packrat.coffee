window.onload = ->
  window.packratClient = client = new Faye.Client(location.origin + "/faye",
    timeout: 30
  )
  client.disable "autodisconnect"
  client.subscribe "/packrat", (message) ->
    if message.reload
      console.log "reloading page"
      location.reload true
    else
      console.log "reloading css..."
      document.getElementById("packrat-css").innerHTML = message.css