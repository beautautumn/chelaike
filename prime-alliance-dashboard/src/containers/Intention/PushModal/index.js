import React, { Component, PropTypes } from 'react'
import { connect } from 'react-redux'
import { connectModal, show as showModal } from 'redux-modal'
import Intention from 'models/intention/intention'
import PushHistory from 'models/intention/pushHistory'
import Entity from 'models/entity'
import { Modal } from 'antd'
import Form from './Form'

@connectModal({ name: 'intentionPush' })
@connect(
  (_state, { id }) => ({
    intention: Intention.select('one', id),
    saving: Intention.getState().saving,
    carsById: Entity.getState().car,
  })
)
export default class PushModal extends Component {
  static propTypes = {
    dispatch: PropTypes.func.isRequired,
    id: PropTypes.number.isRequired,
    carsById: PropTypes.object,
    intention: PropTypes.object,
    saving: PropTypes.bool.isRequired,
    show: PropTypes.bool.isRequired,
    handleHide: PropTypes.func.isRequired,
  }

  handleOk = () => {
    if (!this.props.saving) {
      this.refs.form.submit()
    }
  }

  handleSubmit = data => {
    const { id, dispatch } = this.props
    dispatch(PushHistory.create(id, data))
    dispatch(Intention.fetchOne(id))
  }

  handleAddCar = () => {
    this.props.dispatch(showModal('carList'))
  }

  render() {
    const {
      intention,
      show,
      handleHide,
      carsById,
    } = this.props

    const initialValues = {
      carIds: [],
    }

    return (
      <Modal
        title="意向跟进"
        width={760}
        maskClosable={false}
        visible={show}
        onCancel={handleHide}
        onOk={this.handleOk}
      >
        <Form
          ref="form"
          initialValues={initialValues}
          onSubmit={this.handleSubmit}
          handleAddCar={this.handleAddCar}
          intention={intention}
          carsById={carsById}
        />
      </Modal>
    )
  }
}
