import React, { Component, PropTypes } from 'react'
import { reduxForm } from 'redux-form'
import { Link } from 'react-router'
import styles from './LoginPage.scss'
import TweenOne from 'rc-tween-one'

@reduxForm({
  form: 'login',
  fields: ['login', 'password', 'rememberMe']
})
export default class Form extends Component {
  static propTypes = {
    fields: PropTypes.object.isRequired,
    handleSubmit: PropTypes.func.isRequired,
    authError: PropTypes.object,
  }

  render() {
    const { fields, authError, logging, handleSubmit } = this.props

    const animationConfig = { x: '10px', duration: 100, repeat: 5, yoyo: true }
    const animationProps = {
      moment: (!logging && authError) ? null : 0,
      paused: !authError,
      style: {},
    }

    return (
      <TweenOne animation={animationConfig} {...animationProps} >
        <form onSubmit={handleSubmit}>
          {authError &&
            <div className={styles.error}>
              {authError.message}
            </div>
          }
          <div className={styles.formItem}>
            <input type="text" placeholder="手机号/用户名" {...fields.login} />
          </div>
          <div className={styles.formItem}>
            <input type="password" placeholder="密码" {...fields.password} />
          </div>
          <div className={styles.formItem}>
            <div>
              <div className={styles.checkbox}>
                <input id="rememberMe" type="checkbox" {...fields.rememberMe} />
                <label htmlFor="rememberMe"></label>
              </div>
              <label htmlFor="rememberMe">记住我</label>
            </div>
            <div className={styles.hide}>
              <Link to="/passwords/recover">忘记密码</Link>
            </div>
          </div>
          <div className={styles.buttonContainer}>
            <button className={styles.submit} type="submit">登录</button>
          </div>
        </form>
      </TweenOne>
    )
  }
}
