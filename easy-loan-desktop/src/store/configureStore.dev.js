import { createStore, applyMiddleware } from 'redux'
import logger from 'redux-logger'
import createSagaMiddleware, { END } from 'redux-saga'
import { routerMiddleware as createRouterMiddleware } from 'react-router-redux'
import createHistory from 'history/createBrowserHistory'
import rootReducer from '../models/reducers'

export default function configureStore(initialState) {
  const sagaMiddleware = createSagaMiddleware()
  const history = createHistory()
  const routerMiddleware = createRouterMiddleware(history)

  const store = createStore(
    rootReducer,
    initialState,
    applyMiddleware(
      sagaMiddleware,
      routerMiddleware,
      logger
    )
  )

  if (module.hot) {
    // Enable Webpack hot module replacement for reducers
    module.hot.accept('../models/reducers', () => {
      const nextRootReducer = require('../models/reducers').default
      store.replaceReducer(nextRootReducer)
    })
  }
  store.runSaga = sagaMiddleware.run
  store.close = () => store.dispatch(END)
  store.history = history
  return store
}
