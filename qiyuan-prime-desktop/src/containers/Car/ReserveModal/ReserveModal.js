import React, { Component, PropTypes } from 'react'
import { bindActionCreators } from 'redux'
import { connect } from 'react-redux'
import { show as showNotification } from 'redux/modules/notification'
import {
  fetch as fetchCarRevervation,
  create,
  update,
} from 'redux/modules/carReservations'
import { connectModal } from 'redux-modal'
import { Modal } from 'antd'
import Form from './Form'
import moment from 'moment'
import confirmIfTooBig from 'helpers/confirmIfTooBig'

const errorActionTypes = [create.error.getType(), update.error.getType()]

function fetchData({ store: { getState, dispatch }, props: { id } }) {
  const car = getState().entities.cars[id]
  if (car.reserved) {
    return dispatch(fetchCarRevervation(id))
  }
}

@connectModal({ name: 'carReserve', resolve: fetchData })
@connect(
  (state, { id }) => ({
    car: state.entities.cars[id],
    currentUser: state.auth.user,
    error: state.carReservations.error,
    saved: state.carReservations.saved,
    saving: state.carReservations.saving,
    reservation: state.carReservations.currentReservation,
  }),
  dispatch => ({
    ...bindActionCreators({
      create,
      update,
      showNotification,
    }, dispatch)
  })
)
export default class ReserveModal extends Component {
  static propTypes = {
    show: PropTypes.bool.isRequired,
    car: PropTypes.object.isRequired,
    currentUser: PropTypes.object.isRequired,
    create: PropTypes.func.isRequired,
    update: PropTypes.func.isRequired,
    handleHide: PropTypes.func.isRequired,
    showNotification: PropTypes.func.isRequired,
    saved: PropTypes.bool,
    saving: PropTypes.bool,
    error: PropTypes.string,
    reservation: PropTypes.object,
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

  handleSubmit = (values) => (
    new Promise((resolve, reject) => {
      confirmIfTooBig(values, [
        { key: 'depositWan', name: '定金', unit: '万元' },
        { key: 'closingCostWan', name: '成交价', unit: '万元' },
      ], () => {
        const { car, update, create } = this.props
        const ret = car.reserved ? update(car.id, values) : create(car.id, values)
        ret.then(response => {
          if (errorActionTypes.includes(response.type)) {
            reject(response.error.errors.carReservation)
          } else {
            resolve()
          }
        })
      })
    })
  )

  render() {
    const { car, show, handleHide, reservation } = this.props

    let initialValues

    if (car.reserved) {
      initialValues = reservation
    } else {
      initialValues = {
        proxyInsurance: false,
        salesType: 'retail',
        reservedAt: moment().format('YYYY-MM-DD'),
        sellerId: this.props.currentUser.id
      }
    }

    return (
      <Modal
        title="车辆预定"
        width={760}
        maskClosable={false}
        visible={show}
        onCancel={handleHide}
        onOk={this.handleOk}
      >
        <Form
          ref="form"
          car={car}
          initialValues={initialValues}
          onSubmit={this.handleSubmit}
        />
      </Modal>
    )
  }
}
