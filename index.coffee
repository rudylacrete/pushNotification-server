express = require 'express'
bodyParser = require 'body-parser'
logger = require 'morgan'

app = express()

app.use logger('dev')
app.use bodyParser.json()
app.use bodyParser.urlencoded(extended: true)


# route controllers
authCtrl = require './routes/auth'
apiCtrl = require './routes/api'

# API routing

api = express.Router()

api.use require('./middlewares/authentication')

api.get '/', apiCtrl.getDevices
api.post '/send', apiCtrl.sendMessage
api.post '/register', apiCtrl.registerDevice

app.use '/api/v1', api

# API end

app.post '/login', authCtrl.login

app.listen 3000