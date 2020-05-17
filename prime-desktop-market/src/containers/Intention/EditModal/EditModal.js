import React, { PropTypes } from 'react'
import { PureComponent } from 'react-pure-render'
import { bindActionCreators } from 'redux-polymorphic'
import { connect } from 'react-redux'
import { show as showNotification } from 'redux/modules/notification'
import { create, update } from 'redux/modules/intentions'
import { entitySelector } from 'redux/selectors/entities'
import { connectModal } from 'redux-modal'
import { Modal } from 'antd'
import Form from './Form'

@connectModal({ name: 'intentionEdit' })
@connect(
  (state, { id, as }) => ({
    intention: entitySelector('intentions')(state, id),
    channels: state.entities.channels,
    saved: state.intentions[as].saved,
    saving: state.intentions[as].saving,
    error: state.intentions[as].error,
    enumValues: state.enumValues,
    currentUser: state.auth.user
  }),
  (dispatch, { as }) => ({
    ...bindActionCreators({
      create,
      update,
      showNotification,
    }, dispatch, as)
  })
)
export default class EditModal extends PureComponent {
  static propTypes = {
    show: PropTypes.bool.isRequired,
    intention: PropTypes.object,
    saved: PropTypes.bool,
    error: PropTypes.string,
    saving: PropTypes.bool.isRequired,
    enumValues: PropTypes.object.isRequired,
    handleHide: PropTypes.func.isRequired,
    showNotification: PropTypes.func.isRequired,
    create: PropTypes.func.isRequired,
    update: PropTypes.func.isRequired,
    currentUser: PropTypes.object.isRequired,
    channels: PropTypes.object,
  }

  componentWillReceiveProps(nextProps) {
    if (!this.props.saved && nextProps.saved) {
      this.props.handleHide()
      this.props.showNotification({
        type: 'success',
        message: '保存成功',
      })
    }
    if (!this.props.error && nextProps.error) {
      this.props.showNotification({
        type: 'error',
        message: '错误提示',
        description: nextProps.error,
      })
    }
  }

  handleOk = () => {
    if (!this.props.saving) {
      this.refs.form.submit()
    }
  }

  handleSubmit = data => {
    if (data.licensedAt) {
      data.licensedAt += '-01'
    }
    if (data.id) {
      this.props.update(data)
    } else {
      this.props.create(data)
    }
  }

  render() {
    const { id, enumValues, type, show, handleHide, currentUser, channels } = this.props

    const intention = this.props.intention || {
      intentionType: type,
      seekingCars: [{ brandName: '', seriesName: '' }],
      state: 'untreated'
    }

    let readOnlyChannel
    if (intention && intention.channelId) {
      const channel = channels[intention.channelId]
      if (channel.companyId !== currentUser.company.id) {
        readOnlyChannel = channel
      }
    }

    return (
      <Modal
        title={`${id ? '编辑' : '添加'}意向`}
        width={760}
        maskClosable={false}
        visible={show}
        onCancel={handleHide}
        onOk={this.handleOk}
      >
        <Form
          ref="form"
          initialValues={intention}
          onSubmit={this.handleSubmit}
          enumValues={enumValues}
          readOnlyChannel={readOnlyChannel}
        />
      </Modal>
    )
  }
}
