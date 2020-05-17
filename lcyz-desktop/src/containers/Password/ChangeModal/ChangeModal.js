import React, { Component, PropTypes } from 'react'
import { bindActionCreators } from 'redux'
import { connect } from 'react-redux'
import { show as showNotification } from 'redux/modules/notification'
import { change } from 'redux/modules/password'
import { connectModal } from 'redux-modal'
import { Modal } from 'antd'
import Form from './Form'
import { push } from 'react-router-redux'

@connectModal({ name: 'passwordChange' })
@connect(
  (state) => ({
    changed: state.password.changed,
    changing: state.password.changing
  }),
  dispatch => ({
    ...bindActionCreators({
      change,
      showNotification,
      push
    }, dispatch)
  })
)
export default class ChangeModal extends Component {
  static propTypes = {
    handleHide: PropTypes.func.isRequired,
    show: PropTypes.bool.isRequired,
    showNotification: PropTypes.func.isRequired,
    changed: PropTypes.bool,
    changing: PropTypes.bool,
    push: PropTypes.func.isRequired,
  }

  componentWillReceiveProps(nextProps) {
    if (!this.props.changed && nextProps.changed) {
      this.props.handleHide()
      this.props.showNotification({
        type: 'success',
        message: '修改密码成功',
      })
    }
  }

  handleOk = () => {
    if (!this.props.changing) {
      this.refs.form.submit()
    }
  }

  handleSubmit = (values, dispatch) => (
    new Promise((resolve, reject) => {
      dispatch(change(values))
      .then(response => {
        if (response.type.includes('password/CHANGE_ERROR')) {
          reject({ originalPassword: response.payload.message, _error: '修改密码失败' })
        } else {
          resolve()
          this.props.push('/login')
        }
      })
    })
  )

  render() {
    const { show, handleHide } = this.props
    return (
      <Modal
        title="修改密码"
        width={560}
        maskClosable={false}
        visible={show}
        onCancel={handleHide}
        onOk={this.handleOk}
      >
        <Form ref="form" onSubmit={this.handleSubmit} />
      </Modal>
    )
  }
}
