import React, { PropTypes } from 'react'
import { PureComponent } from 'react-pure-render'
import { bindActionCreators } from 'redux'
import { connect } from 'react-redux'
import { update, create } from 'redux/modules/intentionLevels'
import { show as showNotification } from 'redux/modules/notification'
import { entitySelector } from 'redux/selectors/entities'
import { connectModal } from 'redux-modal'
import { Modal } from 'antd'
import Form from './Form'

@connectModal({ name: 'intentionLevelEdit' })
@connect(
  (state, { id }) => ({
    intentionLevel: entitySelector('intentionLevels')(state, id),
    saved: state.intentionLevels.saved,
    saving: state.intentionLevels.saving
  }),
  dispatch => ({
    ...bindActionCreators({
      update,
      create,
      showNotification,
    }, dispatch)
  })
)
export default class EditModal extends PureComponent {
  static propTypes = {
    show: PropTypes.bool.isRequired,
    intentionLevel: PropTypes.object,
    update: PropTypes.func.isRequired,
    create: PropTypes.func.isRequired,
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
    const { intentionLevel } = this.props
    if (intentionLevel && intentionLevel.id) {
      this.props.update(data)
    } else {
      this.props.create(data)
    }
  }

  render() {
    const { intentionLevel, show, handleHide } = this.props
    const title = intentionLevel ? '编辑客户等级' : '新增客户等级'

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
          initialValues={intentionLevel}
          onSubmit={this.handleSubmit}
        />
      </Modal>
    )
  }
}
