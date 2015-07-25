tokenHelper = require '../lib/tokenHelper'
users = require '../models/user'
_ = require 'underscore'

genToken = (user) ->
  d = new Date
  d = d.setDate d.getDate() + 7
  t = tokenHelper.generate {
    exp: d
    username: user.username
  }
  return {
    token: t
    expires: d
    user: user
  }

validate = (username, password, cb) ->
  user = users.get username

  if username == user.username
    process.nextTick ->
      if password == user.password
        cb null, _.omit(user, 'password')
      else
        cb null, null
  else
    process.nextTick ->
      cb null

auth =
  login: (req, res) ->
    username = req.body.username || ''
    password = req.body.password || ''

    if username == '' or password == ''
      res.status 401
      res.json status: 401, message: 'Invalid credentials'
      return

    validate username, password, (err, dbUser) ->
      if err?
        res.status 500
        res.json status: 500, message 'Internal server error (' + err.message + ')'
        return

      if not dbUser
        res.status 401
        res.json status: 401, message: 'Invalid credentials'
        return

      res.json genToken(dbUser)

module.exports = auth

