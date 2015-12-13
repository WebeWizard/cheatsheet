express = require 'express'
router = express.Router()
process = require 'child_process'

cs = require '../cs'

# GET home page
router.get '/', (req,res,next) ->
  fullUrl = req.protocol + '://' + req.get('host') + req.originalUrl;
  res.render 'index', {url: fullUrl}

router.get '/:hostname', (req,res,next) ->
  hostname = req.params.hostname
  host = cs.hosts[hostname]
  hostSocket = req.io.of("/#{hostname}")
  hostSocket.on 'connection', (socket) ->
    text = if host then host.buffer else "Host #{hostname} is currently not in use"
    socket.emit 'update', text
  res.render 'host', {hostname: hostname}

router.post '/:hostname', (req,res,next) ->
  hostname = req.params.hostname
  cs.addHost hostname if !cs.hosts[hostname]
  buffer = decodeURIComponent req.body.buffer
  cs.hosts[hostname].buffer = buffer
  hostSocket = req.io.of("/#{hostname}")
  process.exec "man #{buffer}", (error, stdout, stderr) ->
    console.log buffer
    hostSocket.emit 'update', stdout
    console.log error
  res.send null

module.exports = router
