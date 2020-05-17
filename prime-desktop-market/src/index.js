require('./semantic-ui')
import 'babel-polyfill'
import React from 'react'
import ReactDOM from 'react-dom'
import configureStore from './redux/configureStore'
import { Provider } from 'react-redux'
import { Router, browserHistory } from 'react-router'
import { syncHistoryWithStore } from 'react-router-redux'
import getRoutes from './routes'
import { RouterScrollContext } from 'react-router-scroll-behavior'
import { ReduxRoutingContext } from 'components'
import { replaceState } from 'redux/modules/makeHydratable'
import { bindActionCreators } from 'redux'

// 全局命名空间，要暴露出去的方法和变量都放在这个里面
global.PrimeDesktop = global.PrimeDesktop || {}

const store = configureStore(browserHistory)

// 后面用于用户登出时重置 state
global.PrimeDesktop.initialState = store.getState()

const appHistory = syncHistoryWithStore(browserHistory, store)

const dest = document.getElementById('content')

ReactDOM.render(
  <Provider store={store} key="provider">
    <Router
      history={appHistory}
      routes={getRoutes()}
      store={store}
      render={
        (props) => (
          <ReduxRoutingContext
            {...props}
            render={
              (props) => <RouterScrollContext {...props} />
            }
          />
        )
      }
    />
  </Provider>,
  dest
)

// 一些快捷方法
global.PrimeDesktop.replaceState = bindActionCreators(replaceState, store.dispatch)

// for debugging
global.PrimeDesktop.store = store

/* global Raven:true */
if (typeof Raven !== 'undefined') {
  store.subscribe(() => {
    const state = store.getState()
    const { user } = state.auth
    if (user) {
      Raven.setUserContext({
        id: user.id,
        username: user.username,
        name: user.name
      })
    }
    Raven.setExtraContext({ state })
  })
}
