import { createStore, applyMiddleware } from 'redux'
import createSagaMiddleware from 'redux-saga'
import thunk from 'redux-thunk'
import { routerMiddleware } from 'react-router-redux'
import createLogger from 'redux-logger'
import { createApiMiddleware } from 'rector/redux'
import makeHydratable from './modules/makeHydratable'
import reducer from './modules/reducer'
import callApi from 'helpers/callApi'
import rootSaga from './sagas'

export default function configureStore(history, initialState) {
  const rootReducer = makeHydratable(reducer)
  const router = routerMiddleware(history)
  const api = createApiMiddleware(callApi)
  const saga = createSagaMiddleware()

  const store = createStore(
    rootReducer,
    initialState,
    applyMiddleware(
      router,
      api,
      saga,
      thunk,
      createLogger()
    )
  )

  saga.run(rootSaga)

  module.hot.accept('./modules/reducer', () => {
    const nextRootReducer = makeHydratable(require('./modules/reducer').default) // eslint-disable-line
    store.replaceReducer(nextRootReducer)
  })

  return store
}
