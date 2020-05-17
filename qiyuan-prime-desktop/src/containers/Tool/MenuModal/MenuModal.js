import React, { Component, PropTypes } from 'react'
import { bindActionCreators } from 'redux'
import { connect } from 'react-redux'
import { connectModal, show as showModal } from 'redux-modal'
import { Modal } from 'antd'

@connectModal({ name: 'toolMenu' })
@connect(
  null,
  dispatch => ({
    ...bindActionCreators({ showModal }, dispatch)
  })
)
export default class MenuModal extends Component {
  static propTypes = {
    show: PropTypes.bool.isRequired,
    handleHide: PropTypes.func.isRequired,
    showModal: PropTypes.func.isRequired
  }

  handleShow = modal => () => {
    this.props.showModal(modal)
  }

  render() {
    const { show, handleHide } = this.props

    return (
      <Modal
        title="你想干嘛"
        maskClosable={false}
        visible={show}
        onCancel={handleHide}
        onOk={handleHide}
      >
        <div className="content">
          <div className="ui relaxed items">
            <a className="item" onClick={this.handleShow('toolSetToken')}>伪装用户</a>
            <a className="item" onClick={this.handleShow('toolReplaceState')}>替换状态</a>
          </div>
        </div>
      </Modal>
    )
  }
}
