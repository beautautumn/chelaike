import React, { PropTypes } from 'react'
import { PureComponent } from 'react-pure-render'
import { bindActionCreators } from 'redux'
import { connect } from 'react-redux'
import { setRecoveryTime } from 'redux/modules/intentionRecoveryTime'
import { show as showNotification } from 'redux/modules/notification'
import { connectModal } from 'redux-modal'
import { Modal } from 'antd'
import Form from './Form'

@connectModal({ name: 'intentionRecoveryTimeEdit' })
@connect(
  (state) => ({
    recycle: state.intentionRecoveryTime.recycle,
    saved: state.intentionRecoveryTime.saved,
    saving: state.intentionRecoveryTime.saving
  }),
  dispatch => ({
    ...bindActionCreators({
      setRecoveryTime,
      showNotification,
    }, dispatch)
  })
)
export default class EditModal extends PureComponent {
  static propTypes = {
    show: PropTypes.bool.isRequired,
    recycle: PropTypes.object,
    setRecoveryTime: PropTypes.func.isRequired,
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
    this.props.setRecoveryTime(data)
  }

  render() {
    const { recycle, show, handleHide } = this.props

    return (
      <Modal
        title="修改意向过期时间"
        maskClosable={false}
        visible={show}
        onCancel={handleHide}
        onOk={this.handleOk}
      >
        <Form
          ref="form"
          initialValues={recycle}
          onSubmit={this.handleSubmit}
        />
      </Modal>
    )
  }
}
