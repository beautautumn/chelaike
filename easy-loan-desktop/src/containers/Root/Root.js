import React, { Component } from 'react'
import PropTypes from 'prop-types'
import { Provider } from 'react-redux'
import { Route, Switch, Redirect } from 'react-router-dom'
import { ConnectedRouter } from 'react-router-redux'
import App from '../App/App'
import Login from '../Login/Login'
import Unauthorized from '../Unauthorized/Unauthorized'
import NotFound from '../NotFound/NotFound'
import { getToken } from '../../models/services/auth'

export default class Root extends Component {
  render() {
    const { store } = this.props

    return (
      <Provider store={store}>
        <ConnectedRouter history={store.history}>
          <div>
            <Switch>
              <Route path="/login" component={Login}/>
              <Route path="/401" component={Unauthorized}/>
              <Route path="/404" component={NotFound}/>
              <AuthRoute path="/" component={App}/>
            </Switch>
          </div>
        </ConnectedRouter>
      </Provider>
    )
  }
}

Root.propTypes = {
  store: PropTypes.object.isRequired,
}

const AuthRoute = ({ component: Component, ...rest }) => (
  <Route {...rest} render={props => (
    getToken() ? (
      <Component {...props}/>
    ) : (
      <Redirect to={{
        pathname: '/login',
        state: { from: props.location }
      }}/>
    )
  )} />
)
