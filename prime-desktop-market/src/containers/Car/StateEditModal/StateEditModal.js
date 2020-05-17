import React, { Component, PropTypes } from 'react'
import { bindActionCreators } from 'redux'
import { connect } from 'react-redux'
import { show as showNotification } from 'redux/modules/notification'
import { create } from 'redux/modules/carStates'
import { connectModal } from 'redux-modal'
import { Modal } from 'antd'
import Form from './Form'
import moment from 'moment'
import { visibleCarStatesSelector } from 'redux/selectors/enumValues'

@connectModal({ name: 'carStateEdit' })
@connect(
  (state, { id }) => ({
    car: state.entities.cars[id],
    saved: state.carStates.saved,
    saving: state.carStates.saving,
    ...visibleCarStatesSelector(state)
  }),
  dispatch => ({
    ...bindActionCreators({
      create,
      showNotification,
    }, dispatch)
  })
)
export default class StateEditModal extends Component {
  static propTypes = {
    show: PropTypes.bool.isRequired,
    car: PropTypes.object.isRequired,
    inHallCarStates: PropTypes.object.isRequired,
    create: PropTypes.func.isRequired,
    showNotification: PropTypes.func.isRequired,
    handleHide: PropTypes.func.isRequired,
    saved: PropTypes.bool,
    saving: PropTypes.bool
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
    const { car } = this.props
    this.props.create(car.id, data)
  }

  render() {
    const { car, inHallCarStates, show, handleHide } = this.props

    const carState = {
      state: car.state,
      sellable: car.sellable,
      occurredAt: moment().format('YYYY-MM-DD'),
      note: car.stateNote
    }

    return (
      <Modal
        title="修改状态"
        width={760}
        maskClosable={false}
        visible={show}
        onCancel={handleHide}
        onOk={this.handleOk}
      >
        <Form
          ref="form"
          initialValues={carState}
          car={car}
          carStates={inHallCarStates}
          onSubmit={this.handleSubmit}
        />
      </Modal>
    )
  }
}
