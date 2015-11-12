express = require 'express'
router = express.Router()

cs = require '../cs'

# GET home page
router.get '/', (req,res,next) ->
  console.log cs.hosts
  cs.addHost 'test2'
  console.log cs.hosts
  res.render 'index', {title: 'Express'}

module.exports = router
