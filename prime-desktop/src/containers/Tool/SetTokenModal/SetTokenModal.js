import React, { Component, PropTypes } from 'react'
import { connectModal } from 'redux-modal'
import { saveToken } from 'redux/modules/auth'
import { Modal } from 'antd'

@connectModal({ name: 'toolSetToken' })
export default class SetTokenModal extends Component {
  static propTypes = {
    show: PropTypes.bool.isRequired,
    handleHide: PropTypes.func.isRequired
  }

  handleOk = () => {
    const token = this.refs.token.value
    if (token) {
      saveToken(token, false)
      window.location.reload()
    }
  }

  render() {
    const { show, handleHide } = this.props

    return (
      <Modal
        title="设置Token"
        maskClosable={false}
        visible={show}
        onCancel={handleHide}
        onOk={this.handleOk}
      >
        <div className="ui form">
          <div className="field">
            <label>Token</label>
            <input ref="token" type="text" />
          </div>
        </div>
      </Modal>
    )
  }
}
