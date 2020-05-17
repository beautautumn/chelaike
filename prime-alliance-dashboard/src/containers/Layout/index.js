import React, { Component, PropTypes } from 'react'
import { connect } from 'react-redux'
import Modal from 'models/modal'
import Auth from 'models/auth'
import EnumValue from 'models/enumValue'
import { connectData } from 'decorators'
import Helmet from 'react-helmet'
import TopBar from './TopBar'
import Container from './Container'
import last from 'lodash/last'

function fetchData(getState, dispatch) {
  const promises = Promise.all([
    dispatch(Auth.fetchMe()),
    dispatch(EnumValue.fetch()),
  ])
  return promises
}

@connectData(fetchData)
@connect(
  _state => ({
    currentUser: Auth.getState().user,
  })
)
export default class AppLayout extends Component {
  static propTypes = {
    dispatch: PropTypes.func.isRequired,
    children: PropTypes.object.isRequired,
    routes: PropTypes.array.isRequired,
    currentUser: PropTypes.object.isRequired,
    location: PropTypes.object.isRequired,
  }

  handleLogout = (event) => {
    event.preventDefault()
    const { dispatch } = this.props
    dispatch(Auth.logout())
  }

  handlePasswordChange = () => {
    const { dispatch } = this.props
    dispatch(Modal.show('passwordChange'))
  }

  showTopBar() {
    const { routes } = this.props
    const lastRoute = last(routes)
    return !['cars/:id'].includes(lastRoute.path)
  }

  render() {
    const { children, currentUser, location } = this.props

    return (
      <div>
        <Helmet titleTemplate="联盟管理 - %s" />
        {this.showTopBar() &&
          <TopBar
            currentUser={currentUser}
            location={location}
            handleLogout={this.handleLogout}
            handlePasswordChange={this.handlePasswordChange}
          />
        }
        <Container>
          {children}
        </Container>
      </div>
    )
  }
}
