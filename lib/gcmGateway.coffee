gcm = require 'node-gcm'
settings = require '../private/settings'

registeredDevices = {}

apiKey = settings?.gcm?.apiKey || ''
if apiKey == ''
  throw new Error 'Missing GCM api key'

sender = new gcm.Sender apiKey

module.exports =
  sendMessage: (message, cb) ->
    m = new gcm.Message()

    m.addData('message', message)

    regIds = Object.keys(registeredDevices).map (k) -> registeredDevices[k]
    return cb 'No device' if regIds.length == 0
    
    console.log 'send message to ' + regIds.length + ' devices'
    sender.sendNoRetry m, regIds, (err, result) ->
      cb err
      if err
        console.error err
      else
        console.log result

  registerDevice: (name, deviceId) ->
    registeredDevices[name] = deviceId
    return true

  getRegisteredDevice: ->
    return registeredDevices