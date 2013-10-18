Builder = require('component-builder')
path = require 'path'
fs = require 'fs'
read = fs.readFileSync
write = fs.writeFile
stylus = require './stylus'
coffee = require './coffee'
util = require 'util'
sqwish = require 'sqwish'
uglify = require 'uglify-js'
_ = require 'lodash'

class Packrat
  constructor: (options, @server, @app) ->
    @channel = '/packrat'
    @watching = false
    _.bindAll this, ['publishChanges', 'change', 'build']
    options = options || {}
    options.coffee = options.coffee || true
    options.stylus = options.stylus || true
    options.path = options.path || process.cwd()
    options.publicPath = options.publicPath || options.path + "/public"
    options.cssExts = options.cssExts || ['css', 'styl', 'less', 'sass']
    options.jsExts = options.jsExts || ['js', 'coffee']
    options.cssFileName = options.cssFileName || 'styles.css'
    options.jsFileName = options.jsFileName || 'javascripts.js'
    @options = options
    self = this

    if @app and "development" is @app.get 'env'
      faye = require 'faye'
      self.pub = new faye.NodeAdapter({mount: '/faye', timeout: 45})
      self.pub.attach @server if @server
      self.pub.addExtension(
        incoming: (message, callback) ->
          return callback message if message.channel is '/meta/subscribe'
          return callback message if message.subscription isnt self.channel
          client = self.pub.getClient()
          self.publishChanges()
          console.log message
          callback message
      )
      @app.use (req, res, next) ->
        res.packrat = self
        next()
    
    @build (err) ->
      console.log err if err

  publishChanges: () ->
    client = @pub.getClient()
    client.publish @channel, {css: @css, js: @js}
    console.log 'assets packed, publishing...'

  change: (path) ->
    console.log 'files changed: ' + path
    self = this
    @build (err) ->
      self.publishChanges() if not err

  build: (done) ->
    self = this
    @builder = new Builder(@options.path)
    @builder.hook "before scripts", coffee(this) if @options.coffee
    @builder.hook "before styles", stylus(this) if @options.stylus
    @builder.hook "before scripts", script(this) for script in @options.scriptHooks if Array.isArray(@options.scriptHooks)
    @builder.hook "before styles", style(this) for style in @options.styleHooks if Array.isArray(@options.styleHooks)
    @builder.copyAssetsTo @options.publicPath
        
    @builder.build (err, res) ->
      return console.log err if err
      self.css = res.css
      self.js = res.require + res.js.replace(/\.coffee/g, ".js")
      console.log err if err
      console.log 'assets packed.'
      if self.app and "development" is self.app.get('env') 
        self.js = read(process.cwd() + '/node_modules/faye/browser/faye-browser.js', "utf8") + self.js + read(__dirname + '/browser/packrat.js')
        if not self.watching
          chokidar = require 'chokidar'
          watcher = chokidar.watch self.options.path + '/components', {ignored: /^\./, ignoreInitial: true}
          self.watching = true
          console.log "watching " + self.options.path + '/components'
          watcher.on 'add', self.change
          watcher.on 'change', self.change
          watcher.on 'unlink', self.change
          watcher.on 'error', (err) ->
            console.log err
      
      # minify stuff here
      write "#{self.options.publicPath}/#{self.options.cssFileName}", self.css, (err) ->
        console.log err if err
      write "#{self.options.publicPath}/#{self.options.jsFileName}", self.js, (err) ->
        console.log err if err
      done err if done

merge = (a, b) ->
  if a and b
    for key of b
      a[key] = b[key]
  a

merge Packrat.prototype, require('events').EventEmitter.prototype
module.exports = Packrat