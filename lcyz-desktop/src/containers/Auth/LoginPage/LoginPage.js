import React, { Component, PropTypes } from 'react'
import { bindActionCreators } from 'redux'
import { connect } from 'react-redux'
import { login } from 'redux/modules/auth'
import can from 'helpers/can'
import { Link } from 'react-router'
import Form from './Form'
import styles from './LoginPage.scss'
import bmLogo from './bm-logo.png'
import xgcLogo from './xgc-logo.png'
import lcyzLogo from './lcyz-logo.png'
import config from 'config'

const routes = {
  '/cars': '在库车辆查询',
  '/stock_out_cars': '已出库车辆查询',
  '/licenses': '牌证信息查看',
  '/prepare_records': '整备信息查看',
  '/company': '公司信息设置',
  '/roles': '角色管理',
  '/users': '员工管理',
  '/setting/shops': '业务设置'
}

@connect(
  state => ({
    currentUser: state.auth.user,
    authError: state.auth.error,
    logging: state.auth.logging,
  }),
  dispatch => bindActionCreators({ login }, dispatch)
)
export default class LoginPage extends Component {
  static propTypes = {
    login: PropTypes.func.isRequired,
    currentUser: PropTypes.object,
    authError: PropTypes.object,
    logging: PropTypes.bool.isRequired,
  }

  componentWillMount() {
    document.body.style.backgroundColor = 'white'
  }

  componentWillUnmount() {
    document.body.style.backgroundColor = null
  }

  getHomePage() {
    for (const key of Object.keys(routes)) {
      if (can(routes[key])) {
        return key
      }
    }
  }

  handleSubmit = (data) => {
    this.props.login(data)
  }

  render() {
    const { authError, logging } = this.props

    const initialValues = { rememberMe: true }

    let logo = bmLogo
    let needRegister = false
    if (config.appName === '良车驿站') {
      logo = lcyzLogo
    } else if (config.appName === '选个车') {
      logo = xgcLogo
    } else {
      needRegister = true
    }

    return (
      <div className={styles.login}>
        <div className={styles.logo}>
          <img src={logo} alt="logo" />
        </div>
        <div className={styles.form}>
          <Form
            initialValues={initialValues}
            onSubmit={this.handleSubmit}
            authError={authError}
            logging={logging}
          />
          {needRegister &&
            <div className={styles.formItem}>
              <div>没有帐号？<Link to="/signup">注册</Link></div>
            </div>
          }
        </div>
      </div>
    )
  }
}
