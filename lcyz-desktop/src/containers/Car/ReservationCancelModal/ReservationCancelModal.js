import React, { Component, PropTypes } from 'react'
import { bindActionCreators } from 'redux'
import { connect } from 'react-redux'
import { fetch as fetchCarRevervation, cancel } from 'redux/modules/carReservations'
import { show as showNotification } from 'redux/modules/notification'
import { Modal } from 'antd'
import Form from './Form'
import moment from 'moment'
import { connectModal } from 'redux-modal'

function fetchData({ store: { getState, dispatch }, props: { id } }) {
  const car = getState().entities.cars[id]
  if (car.reserved) {
    return dispatch(fetchCarRevervation(id))
  }
}

@connectModal({ name: 'carReservationCancel', resolve: fetchData })
@connect(
  (state, { id }) => ({
    car: state.entities.cars[id],
    reservation: state.carReservations.currentReservation,
    saved: state.carReservations.saved,
    saving: state.carReservations.saving
  }),
  dispatch => ({
    ...bindActionCreators({
      cancel,
      showNotification,
    }, dispatch)
  })
)
export default class ReservationCancelModal extends Component {
  static propTypes = {
    show: PropTypes.bool.isRequired,
    car: PropTypes.object.isRequired,
    reservation: PropTypes.object.isRequired,
    handleHide: PropTypes.func.isRequired,
    showNotification: PropTypes.func.isRequired,
    saved: PropTypes.bool,
    saving: PropTypes.bool,
    cancel: PropTypes.func
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
    this.props.cancel(car.id, data)
  }

  render() {
    const { car, reservation, show, handleHide } = this.props

    const initialValues = {
      saved: moment().format('YYYY-MM-DD'),
    }

    return (
      <Modal
        title="取消预定"
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
          car={car}
          reservation={reservation}
        />
      </Modal>
    )
  }
}
