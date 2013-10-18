module.exports =

  injectAt: (marker, str, payload) ->
    location = str.indexOf(marker)
    if location is -1
      console.log 'packrat: failed to locate ' + marker + ', trying </body'
      marker = '</body'
      location = str.indexOf(marker)
      if location is -1
        console.log 'packrat: failed to locate ' + marker + ', trying </html'
        marker = '</html'
        location = str.indexOf(marker)
      
    if location isnt -1
      str = str.substring(0, location) + payload + str.substring(location)
    else
      console.log 'packrat: failed to inject'
    return str

  injectHtml: (str, css, js) ->
    str = @injectAt '</head', str, css
    str = @injectAt '<script', str, js
    return str