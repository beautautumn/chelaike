import feeble from 'feeble'
import createLogger from 'redux-logger'
import callApi from 'helpers/callApi'
import models from './models'
import routes from './config/routes'

const app = feeble({
  callApi,
})

app.model(...models)

if (process.env.NODE_ENV === 'development') {
  app.middleware(
    createLogger()
  )
}

app.router(routes)

app.start()

export default app
