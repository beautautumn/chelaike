import React from 'react'
import PropTypes from 'prop-types'
import { connect } from 'react-redux'
import { LoginForm } from '../../components'
import { Row } from 'antd'
import { code as codeRequest, login } from '../../models/reducers/auth'

class Login extends React.Component {
  render() {
    return (
      <Row type="flex" justify="space-around" align="middle" style={{ height: '100vh' }}>
        <LoginForm {...this.props} />
      </Row>
    )
  }
}

Login.propTypes = {
  loading: PropTypes.bool.isRequired,
  codeRequest: PropTypes.func.isRequired,
  login: PropTypes.func.isRequired,
}

export default connect(
  state => ({
    loading: state.auth.loading,
    stopCountdown: state.auth.stopCountdown,
  }),
  { codeRequest, login }
)(Login)
