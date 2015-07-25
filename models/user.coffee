users =
  'test':
    username: 'test'
    password: '1234'
    role: 'admin'

module.exports =
  get: (username) ->
    return users[username]