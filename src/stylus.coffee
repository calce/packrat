read = require('fs').readFileSync
path = require 'path'
stylus = require 'stylus'

module.exports = (packrat) ->
  return (pkg, next) ->
    return next() if pkg.config.styles is undefined
  
    files = pkg.config.styles.filter((file) ->
      path.extname(file) is ".styl"
    )
  
    s = stylus('')
    files.forEach (file, i) ->
      s.import pkg.path(file)
      pkg.removeFile "styles", file
    s.render (err, css) ->
      return next err if err
      filename = 'styles.css'    
      pkg.addFile "styles", filename, css
  
    next()
