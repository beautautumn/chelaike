import React, { Component, PropTypes } from 'react'
import { bindActionCreators } from 'redux'
import { connect } from 'react-redux'
import { login } from 'redux/modules/auth'
import can from 'helpers/can'
import RetinaImage from 'react-retina-image'
import Form from './Form'
import styles from './LoginPage.scss'
import logo from './logo.png'
import logo2x from './logo@2x.png'
import sysName from './sysName.png'

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

    return (
      <div className={styles.login}>
        <div>
          <RetinaImage className={styles.logo} src={[logo, logo2x]} />
          <RetinaImage className={styles.sysName} src={[sysName, sysName]} />
        </div>
        <div className={styles.form}>
          <Form
            initialValues={initialValues}
            onSubmit={this.handleSubmit}
            authError={authError}
            logging={logging}
          />
        </div>
      </div>
    )
  }
}
