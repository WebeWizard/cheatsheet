express = require 'express'
router = express.Router()

# GET users listing
router.get '/a', (req,res,next) ->
  res.send 'respond with a resource'

module.exports = router
