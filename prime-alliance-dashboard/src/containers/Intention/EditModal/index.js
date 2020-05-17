import React, { Component, PropTypes } from 'react'
import { connect } from 'react-redux'
import { connectModal, show as showModal } from 'redux-modal'
import Intention from 'models/intention/intention'
import EnumValue from 'models/enumValue'
import Entity from 'models/entity'
import { Modal } from 'antd'
import Form from './Form'

@connectModal({ name: 'intentionEdit' })
@connect(
  (_state, { id }) => ({
    intention: Intention.select('one', id),
    saving: Intention.getState().saving,
    error: Intention.getState().error,
    enumValues: EnumValue.getState(),
    carsById: Entity.getState().car,
  })
)
export default class EditModal extends Component {
  static propTypes = {
    dispatch: PropTypes.func.isRequired,
    show: PropTypes.bool.isRequired,
    intention: PropTypes.object,
    error: PropTypes.string,
    saving: PropTypes.bool.isRequired,
    enumValues: PropTypes.object.isRequired,
    handleHide: PropTypes.func.isRequired,
    type: PropTypes.string,
    carsById: PropTypes.object,
  }

  handleOk = () => {
    if (!this.props.saving) {
      this.refs.form.submit()
    }
  }

  handleSubmit = data => {
    const { dispatch } = this.props
    if (!data.appoitment) {
      delete data.appoitmentCar
    }
    if (data.id) {
      dispatch(Intention.update(data))
    } else {
      dispatch(Intention.create(data))
    }
  }

  handleAddCar = () => {
    const { dispatch } = this.props
    dispatch(showModal('carList'))
  }

  render() {
    const { show, handleHide, enumValues, type, carsById } = this.props

    const intention = this.props.intention || {
      intentionType: type,
      seekingCars: [{ brandName: '', seriesName: '' }],
      allianceState: 'untreated',
      appoitment: false,
    }

    intention.appoitment = !!(intention.appoitmentCar && intention.appoitmentCar.appointmentTime)

    const title = intention.intentionType === 'seek' ? '求购' : '出售'
    const action = intention.id ? '编辑' : '添加'

    return (
      <Modal
        title={`${action}${title}意向`}
        width={760}
        maskClosable={false}
        visible={show}
        onCancel={handleHide}
        onOk={this.handleOk}
      >
        <Form
          ref="form"
          initialValues={intention}
          enumValues={enumValues}
          onSubmit={this.handleSubmit}
          handleAddCar={this.handleAddCar}
          carsById={carsById}
        />
      </Modal>
    )
  }
}
