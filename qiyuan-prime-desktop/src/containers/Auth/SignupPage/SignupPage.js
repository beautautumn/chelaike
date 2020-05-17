import React, { Component, PropTypes } from 'react'
import { bindActionCreators } from 'redux'
import { connect } from 'react-redux'
import { push } from 'react-router-redux'
import { show as showModal } from 'redux-modal'
import styles from './SignupPage.scss'
import Form from './Form'
import { signup } from 'redux/modules/auth'
import { fetch as fetchLocation } from 'redux/modules/location'
import TosModal from './TosModal'
import { Link } from 'react-router'

@connect(
  (state) => ({
    registering: state.auth.registering,
    location: state.location
  }),
  dispatch => ({
    ...bindActionCreators({
      signup,
      push,
      showModal,
      fetchLocation
    }, dispatch)
  })
)
export default class SignupPage extends Component {
  static propTypes = {
    user: PropTypes.object,
    location: PropTypes.object.isRequired,
    push: PropTypes.func.isRequired,
    signup: PropTypes.func.isRequired,
    showModal: PropTypes.func.isRequired,
    fetchLocation: PropTypes.func.isRequired,
    registering: PropTypes.bool,
  }

  componentWillMount() {
    this.props.fetchLocation()
  }

  handleSubmit = (data) => (
    new Promise((resolve, reject) => {
      this.props.signup(data)
      .then(response => {
        if (response.type === signup.error.getType()) {
          reject(response.error.errors)
        } else {
          resolve()
        }
      })
    })
  )

  render() {
    const { showModal, registering, location } = this.props

    const initialValues = {
      company: {
        province: location.province,
        city: location.city
      }
    }

    return (
      <div className={styles.signup}>
        <TosModal />
        <div className="ui middle aligned center aligned grid">
          <div className="column">
            <h2 className="ui teal image header">
              <div className="content">
                注册车来客市场管理平台
              </div>
            </h2>
            <Form
              initialValues={initialValues}
              onSubmit={this.handleSubmit}
              registering={registering}
              showModal={showModal}
            />
            <div className="ui message">
              已有账号？<Link to="/login">登录</Link>
            </div>
          </div>
        </div>
      </div>
    )
  }
}
