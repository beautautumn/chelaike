import React, { PropTypes } from 'react'
import { Router, Route, IndexRedirect } from 'feeble/router'
import { ReduxRoutingContext } from 'components'
import { RouterScrollContext } from 'react-router-scroll-behavior'
import App from 'containers/App'
import Layout from 'containers/Layout'
import NotFound from 'containers/NotFound'
import * as Auth from 'containers/Auth'
import * as Car from 'containers/Car'
import * as Role from 'containers/Role'
import * as User from 'containers/User'
import * as Setting from 'containers/Setting'
import * as Intention from 'containers/Intention'
import * as Alliance from 'containers/Alliance'

export default function routes({ history, store }) {
  return (
    <Router
      history={history}
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
    >
      <Route component={App}>
        <Route path="/login" component={Auth.LoginPage} />
        <Route path="/" component={Layout}>
          <IndexRedirect to="cars" />
          <Route path="cars" component={Car.InStockListPage} />
          <Route path="cars/:id/edit" component={Car.EditPage} />
          <Route path="cars/:id" component={Car.DetailPage} />
          <Route path="stock_out_cars" component={Car.StockOutListPage} />
          <Route path="roles" component={Role.ListPage} />
          <Route path="roles/new" component={Role.EditPage} />
          <Route path="roles/:id/edit" component={Role.EditPage} />
          <Route path="users" component={User.ListPage} />
          <Route path="users/new" component={User.EditPage} />
          <Route path="users/:id/edit" component={User.EditPage} />
          <Route path="intentions" component={Intention.ListPage} />
          <Route path="alliance" component={Alliance.ListPage} />
          <Route path="setting" component={Setting.Layout} >
            <IndexRedirect to="channels" />
            <Route path="channels" component={Setting.Channel.ListPage} />
            <Route path="intention_levels" component={Setting.IntentionLevel.ListPage} />
          </Route>
        </Route>
        <Route path="*" component={NotFound} status={404} />
      </Route>
    </Router>
  )
}

routes.propTypes = {
  history: PropTypes.object.isRequired,
  store: PropTypes.object.isRequired,
}
