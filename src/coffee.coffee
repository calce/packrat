coffeescript = require 'coffee-script'
read = require('fs').readFileSync
path = require 'path'

module.exports = (packrat) ->
 return (pkg, next) ->
    return next() if pkg.config.scripts is undefined
    files = pkg.config.scripts.filter((file) ->
      path.extname(file) is ".coffee"
    )
  
    return next() if files.length is 0
    files.forEach (file, i) ->
      realpath = pkg.path(file)
      str = read realpath, "utf8"
      compiled = coffeescript.compile(str,
        filename: realpath
        bare: true
      )
      filename = file.replace(".coffee", ".js")        
      pkg.addFile "scripts", filename, compiled
      pkg.removeFile "scripts", file
  
    next()
