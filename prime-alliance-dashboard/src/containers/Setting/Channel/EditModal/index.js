import React, { Component, PropTypes } from 'react'
import { connect } from 'react-redux'
import Channel from 'models/channel'
import { connectModal } from 'redux-modal'
import { Modal } from 'antd'
import Form from './Form'

@connectModal({ name: 'channelEdit' })
@connect(
  (_state, { id }) => ({
    channel: Channel.select('one', id),
    saving: Channel.getState().saving,
  }),
)
export default class EditModal extends Component {
  static propTypes = {
    dispatch: PropTypes.func.isRequired,
    show: PropTypes.bool.isRequired,
    channel: PropTypes.object,
    create: PropTypes.func.isRequired,
    handleHide: PropTypes.func.isRequired,
    saving: PropTypes.bool.isRequired,
  }

  handleOk = () => {
    if (!this.props.saving) {
      this.refs.form.submit()
    }
  }

  handleSubmit = (data) => {
    const { dispatch, channel } = this.props
    if (channel && channel.id) {
      dispatch(Channel.update(data))
    } else {
      dispatch(Channel.create(data))
    }
  }

  render() {
    const { channel, show, handleHide } = this.props
    const title = channel ? '编辑渠道' : '新增渠道'

    return (
      <Modal
        title={title}
        maskClosable={false}
        visible={show}
        onCancel={handleHide}
        onOk={this.handleOk}
      >
        <Form
          ref="form"
          initialValues={channel}
          onSubmit={this.handleSubmit}
        />
      </Modal>
    )
  }
}
