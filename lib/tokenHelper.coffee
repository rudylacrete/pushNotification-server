settings = require '../private/settings'
jwt = require 'jwt-simple'

secret = settings?.token?.secret || ''
if secret == ''
  throw new Error 'Token secret is not defined'

module.exports =
  generate: (payload) ->
    jwt.encode payload, secret
  decode: (token) ->
    jwt.decode token, secret