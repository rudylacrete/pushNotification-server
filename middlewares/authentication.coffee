tokenHelper = require '../lib/tokenHelper'

module.exports = (req, res, next) ->
  token = (req.body and req.body.access_token) or
  (req.quey and req.query.access_token) or req.headers['x-access-token']

  if not token
    res.status 401
    res.json status: 401, message: 'Unauthorized'
    return

  try
    decodedToken = tokenHelper.decode token
    
    if decodedToken.exp <= Date.now()
      res.status 400
      res.json status: 400, message: 'Token expired'
      return

    next()

  catch e
    res.status 500
    res.json {
      status: 500
      message: 'Internal server error (' + (e.message || '') + ')'
    }