import React, { Component, PropTypes } from 'react'
import { bindActionCreators } from 'redux'
import { connect } from 'react-redux'
import { fetchMe, logout } from 'redux/modules/auth'
import { fetch as fetchEnumValues } from 'redux/modules/enumValues'
import { show as showModal } from 'redux-modal'
import { GoToTopButton } from 'components'
import { MenuModal, ReplaceStateModal, SetTokenModal } from '../Tool'
import { WhatsNewModal } from '../WhatsNew'
import { connectData } from 'decorators'
import Topbar from './Topbar/Topbar'
import styles from './AppLayout.scss'
import cx from 'classnames'
import last from 'lodash/last'
import cheet from 'cheet.js'
import Helmet from 'react-helmet'

function fetchData(getState, dispatch) {
  const promises = Promise.all([
    dispatch(fetchMe()),
    dispatch(fetchEnumValues()),
  ])
  return promises
}

@connectData(fetchData)
@connect(
  state => ({
    currentUser: state.auth.user
  }),
  dispatch => ({
    ...bindActionCreators({
      logout,
      showModal
    }, dispatch)
  })
)
export default class AppLayout extends Component {
  static propTypes = {
    children: PropTypes.object.isRequired,
    currentUser: PropTypes.object,
    logout: PropTypes.func.isRequired,
    location: PropTypes.object.isRequired,
    routes: PropTypes.array.isRequired,
    showModal: PropTypes.func.isRequired
  }

  componentDidMount() {
    cheet('↑ ↑ ↓ ↓ ← → ← → b a', () => {
      this.props.showModal('toolMenu')
    })
  }

  handleLogout = (event) => {
    event.preventDefault()
    this.props.logout()
  }

  isNoMenuPage() {
    const { routes } = this.props
    const lastRoute = last(routes)
    return [
      'cars/:id', 'cars/:id/edit', 'cars/new', 'open_cars/:id',
      'users/new', 'users/:id/edit'
    ].includes(lastRoute.path)
  }

  renderBar() {
    const { location, currentUser, showModal } = this.props
    if (!this.isNoMenuPage()) {
      return (
        <Topbar
          currentUser={currentUser}
          location={location}
          handleLogout={this.handleLogout}
          handleShowModal={showModal}
        />
      )
    }
  }

  render() {
    return (
      <div className={cx(styles.wrapper, 'pusher')}>
        <Helmet titleTemplate="车来客市场版 - %s" />
        {this.renderBar()}

        <div className={styles.main}>
          <div className={cx(styles.mainContainer, 'ui', 'container')}>
            {this.props.children}
          </div>
        </div>
        <GoToTopButton />
        <MenuModal />
        <ReplaceStateModal />
        <SetTokenModal />
        <WhatsNewModal />
      </div>
    )
  }
}
