import React, { Component, PropTypes } from 'react'
import { connect } from 'react-redux'
import { connectModal } from 'redux-modal'
import Intention from 'models/intention/intention'
import { Modal } from 'antd'
import Form from './Form'

@connectModal({ name: 'intentionAssign' })
@connect()
export default class AssignModal extends Component {
  static propTypes = {
    dispatch: PropTypes.func.isRequired,
    show: PropTypes.bool.isRequired,
    handleHide: PropTypes.func.isRequired,
    ids: PropTypes.array.isRequired,
  }

  handleOk = () => {
    this.refs.form.submit()
  }

  handleSubmit = ({ companyId }) => {
    const { dispatch, ids } = this.props
    dispatch(Intention.assign({ intentionIds: ids, companyId }))
  }

  render() {
    const { show, handleHide, ids } = this.props

    return (
      <Modal
        title="分配意向"
        width={760}
        maskClosable={false}
        visible={show}
        onCancel={handleHide}
        onOk={this.handleOk}
      >
        <Form
          ref="form"
          count={ids.length}
          onSubmit={this.handleSubmit}
        />
      </Modal>
    )
  }
}

