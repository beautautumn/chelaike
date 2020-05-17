import React, { Component, PropTypes } from 'react'
import { connect } from 'react-redux'
import Level from 'models/intention/level'
import { connectModal } from 'redux-modal'
import { Modal } from 'antd'
import Form from './Form'

@connectModal({ name: 'levelEdit' })
@connect(
  (_state, { id }) => ({
    level: Level.select('one', id),
    saving: Level.getState().saving,
  }),
)
export default class EditModal extends Component {
  static propTypes = {
    dispatch: PropTypes.func.isRequired,
    show: PropTypes.bool.isRequired,
    level: PropTypes.object,
    handleHide: PropTypes.func.isRequired,
    saving: PropTypes.bool.isRequired,
  }

  handleOk = () => {
    if (!this.props.saving) {
      this.refs.form.submit()
    }
  }

  handleSubmit = (data) => {
    const { dispatch, level } = this.props
    if (level && level.id) {
      dispatch(Level.update(data))
    } else {
      dispatch(Level.create(data))
    }
  }

  render() {
    const { level, show, handleHide } = this.props
    const title = level ? '编辑客户等级' : '新增客户等级'

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
          initialValues={level}
          onSubmit={this.handleSubmit}
        />
      </Modal>
    )
  }
}
