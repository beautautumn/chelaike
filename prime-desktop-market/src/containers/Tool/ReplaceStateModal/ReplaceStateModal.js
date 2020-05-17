import React, { Component, PropTypes } from 'react'
import { bindActionCreators } from 'redux'
import { connect } from 'react-redux'
import { HYDRATE_STATE } from 'redux/modules/makeHydratable'
import { Modal } from 'antd'
import { connectModal } from 'redux-modal'
import Textarea from 'react-textarea-autosize'

@connectModal({ name: 'toolReplaceState' })
@connect(
  null,
  dispatch => ({
    ...bindActionCreators({
      replace: (state) => ({
        type: HYDRATE_STATE,
        state
      })
    }, dispatch)
  })
)
export default class ReplaceStateModal extends Component {
  static propTypes = {
    show: PropTypes.bool.isRequired,
    handleHide: PropTypes.func.isRequired,
    replace: PropTypes.func.isRequired,
  }

  handleOk = () => {
    const state = JSON.parse(this.refs.state.value)
    this.props.replace(state)
  }

  render() {
    const { show, handleHide } = this.props

    return (
      <Modal
        title="替换状态"
        maskClosable={false}
        visible={show}
        onCancel={handleHide}
        onOk={this.handleOk}
      >
        <div className="content">
          <div className="ui form">
            <div className="field">
              <Textarea rows={10} ref="state" />
            </div>
          </div>
        </div>
      </Modal>
    )
  }
}
