module.exports =

  injectAt: (marker, str, payload) ->
    location = str.indexOf(marker)
    if location is -1
      console.log str
      console.log 'packrat: failed to locate ' + marker
    else
      console.log 'located ' + marker
      str = str.substring(0, location) + payload + str.substring(location)
    return str

  injectHtml: (str, css, js) ->
    str = @injectAt '</head', str, css
    str = @injectAt '<script', str, js
    return str