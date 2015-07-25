gateway = require '../lib/gcmGateway'

api =
  getDevices: (req, res) ->
    res.json gateway.getRegisteredDevice()

  sendMessage: (req, res) ->
    message = req.body.message
    return res.status(500).send 'Missing message' if not message?
    gateway.sendMessage message, (err)->
      if err?
        res.json {ok: false, err}
      else
        res.json {ok: true}

  registerDevice: (req, res) ->
    deviceId = req.body.token
    name = req.body.name
    if not name or not deviceId
      return res.json {ok: false}
    gateway.registerDevice name, deviceId
    res.json {ok: true}

module.exports = api