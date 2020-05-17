import 'babel-polyfill'
import ReactDOM from 'react-dom'
import app from './app'

// 全局命名空间，要暴露出去的方法和变量都放在这个里面
global.PrimeAllianceDashboard = global.PrimeAllianceDashboard || {}

global.PrimeAllianceDashboard.app = app

/* global Raven:true */
if (typeof Raven !== 'undefined') {
  app.store.subscribe(() => {
    const state = app.store.getState()
    const { user } = state.auth
    if (user) {
      Raven.setUserContext({
        id: user.id,
        username: user.username,
        name: user.name,
      })
    }
    Raven.setExtraContext({ state })
  })
}

ReactDOM.render(app.tree(), document.getElementById('app'))
