import React, { PropTypes } from 'react'
import { PureComponent } from 'react-pure-render'
import { bindActionCreators } from 'redux'
import { connect } from 'react-redux'
import { update } from 'redux/modules/expirationSettings'
import { show as showNotification } from 'redux/modules/notification'
import { connectModal } from 'redux-modal'
import { Modal } from 'antd'
import Form from './Form'
import { entitySelector } from 'redux/selectors/entities'

@connectModal({ name: 'guestReminderEdit' })
@connect(
  (state, { id }) => ({
    setting: entitySelector('expirationSettings')(state, id),
    saved: state.expirationSettings.saved,
    saving: state.expirationSettings.saving
  }),
  dispatch => (
    bindActionCreators({
      update,
      showNotification,
    }, dispatch)
  )
)
export default class EditModal extends PureComponent {
  static propTypes = {
    show: PropTypes.bool.isRequired,
    setting: PropTypes.object,
    update: PropTypes.func.isRequired,
    showNotification: PropTypes.func.isRequired,
    handleHide: PropTypes.func.isRequired,
    saving: PropTypes.bool.isRequired,
    saved: PropTypes.bool
  }

  componentWillReceiveProps(nextProps) {
    if (!this.props.saved && nextProps.saved) {
      this.props.handleHide()
      this.props.showNotification({
        type: 'success',
        message: '保存成功',
      })
    }
  }

  handleOk = () => {
    if (!this.props.saving) {
      this.refs.form.submit()
    }
  }

  handleSubmit = (data) => {
    const { update, id } = this.props
    update({ id, ...data })
  }

  render() {
    const { setting, show, handleHide } = this.props

    return (
      <Modal
        title={setting.name}
        maskClosable={false}
        visible={show}
        onCancel={handleHide}
        onOk={this.handleOk}
      >
        <Form
          ref="form"
          initialValues={setting}
          onSubmit={this.handleSubmit}
        />
      </Modal>
    )
  }
}
