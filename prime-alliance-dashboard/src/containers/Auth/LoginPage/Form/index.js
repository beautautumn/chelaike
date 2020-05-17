import React, { PropTypes } from 'react'
import { reduxForm } from 'redux-form'
import styles from '../style.scss'
import TweenOne from 'rc-tween-one'

function Form({ fields, handleSubmit, authError, logging }) {
  let errorMessage

  if (authError) {
    errorMessage = (
      <div className={styles.error}>
        {authError}
      </div>
    )
  }

  const animationConfig = { x: '10px', duration: 100, repeat: 5, yoyo: true }
  const animationProps = {
    moment: (!logging && authError) ? null : 0,
    paused: !authError,
    style: {},
  }

  return (
    <div className={styles.login}>
      <h1 className={styles.title}>登录联盟管理后台</h1>
      <TweenOne animation={animationConfig} {...animationProps} >
        <form className={styles.form} onSubmit={handleSubmit}>
          {errorMessage}
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
          </div>
          <div className={styles.buttonContainer}>
            <button className={styles.submit} type="submit">登录</button>
          </div>
        </form>
      </TweenOne>
    </div>
  )
}

Form.propTypes = {
  fields: PropTypes.object.isRequired,
  handleSubmit: PropTypes.func.isRequired,
  authError: PropTypes.string,
  logging: PropTypes.bool.isRequired,
}

export default reduxForm({
  form: 'login',
  fields: ['login', 'password', 'rememberMe'],
})(Form)
