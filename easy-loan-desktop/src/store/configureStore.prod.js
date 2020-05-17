import { createStore, applyMiddleware } from 'redux'
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
      routerMiddleware
    )
  )

  store.runSaga = sagaMiddleware.run
  store.close = () => store.dispatch(END)
  store.history = history
  return store
}
