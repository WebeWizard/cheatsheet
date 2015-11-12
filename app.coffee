express = require 'express'
path = require 'path'
favicon = require 'serve-favicon'
logger = require 'morgan'
cookieParser = require 'cookie-parser'
bodyParser = require 'body-parser'

app = express()

debug = require('debug') 'cs:server'
http = require 'http'

normalizePort = (val) ->
  port = parseInt val, 10
  if isNaN(port) then return val
  if port >= 0 then return port
  false

# Get port and store in Express
port = normalizePort(process.env.PORT or 4321)
app.set 'port', port

onListening = ->
  addr = server.address()
  bind = typeof port is 'string' ? "Pipe #{port}" : "Port #{port}"
  debug "Listening on #{bind}"

onError = (error) ->
  if error isnt 'listen'
    throw error

  bind = typeof port is 'string' ? "Pipe #{port}" : "Port #{port}"

  switch error.code
    when 'EACCES'
      console.error "#{bind} requires elevated privileges"
      process.exit 1
    when 'EADDRINUSE'
      console.error "#{bind} is already in use"
      process.exit 1
    else throw error

# Create the HTTP Server
server = http.createServer app
io = require('socket.io') server

server.listen port
server.on 'error', onError
server.on 'listening', onListening

# view engine setup
app.set 'views', path.join(__dirname, 'views')
app.set 'view engine', 'hjs'

# uncomment after placing your favicon in /public
#app.use favicon path.join __dirname, 'public', 'favicon.ico'
app.use logger 'dev'
app.use bodyParser.json()
app.use bodyParser.urlencoded {extended: false}
app.use cookieParser()
app.use require('node-sass-middleware') {
  src: path.join __dirname, 'public'
  dest: path.join __dirname, 'public'
  indentedSyntax: true
  sourceMap: true
}

host = require './routes/host'

app.use (req,res,next) ->
  req.io = io
  next()

app.use '/', host

# catch 404 and forward to error handler
app.use (req,res,next) ->
  err = new Error 'Not Found'
  err.status = 404;
  next err

# development error handler
# will print stacktrace
if (app.get 'env') is 'development'
  app.use (err,req,res,next) ->
    res.status err.status or 500
    res.render 'error', {message: err.message, error: err }

# production error handler
# no stacktraces leaked to user
app.use (err,req,res,next) ->
  res.status err.status or 500
  res.render 'error', {message: err.message, err: {}}


module.exports = app
