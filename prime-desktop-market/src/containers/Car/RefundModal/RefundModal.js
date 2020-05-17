import React, { Component, PropTypes } from 'react'
import { bindActionCreators } from 'redux'
import { connect } from 'react-redux'
import { create } from 'redux/modules/refundInventories'
import { fetch as fetchStockOutInventory } from 'redux/modules/stockOutInventories'
import Form from './Form'
import { Modal } from 'antd'
import { connectModal } from 'redux-modal'

function fetchData({ store: { dispatch }, props: { id } }) {
  return dispatch(fetchStockOutInventory(id))
}

@connectModal({ name: 'carRefund', resolve: fetchData })
@connect(
  (state, { id }) => ({
    car: state.entities.cars[id],
    stockOutInventory: state.stockOutInventories.currentStockOutInventory,
    saved: state.refundInventories.saved,
    saving: state.refundInventories.saving
  }),
  dispatch => ({
    ...bindActionCreators({
      create,
    }, dispatch)
  })
)
export default class RefundModal extends Component {
  static propTypes = {
    show: PropTypes.bool.isRequired,
    car: PropTypes.object.isRequired,
    stockOutInventory: PropTypes.object.isRequired,
    create: PropTypes.func.isRequired,
    handleHide: PropTypes.func.isRequired,
    saving: PropTypes.bool.isRequired,
    saved: PropTypes.bool
  }

  componentWillReceiveProps(nextProps) {
    if (!this.props.saved && nextProps.saved) {
      this.props.handleHide()
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
    const { car, stockOutInventory, show, handleHide } = this.props

    return (
      <Modal
        title="车辆回库"
        width={760}
        maskClosable={false}
        visible={show}
        onCancel={handleHide}
        onOk={this.handleOk}
      >
        <Form
          ref="form"
          car={car}
          stockOutInventory={stockOutInventory}
          onSubmit={this.handleSubmit}
        />
      </Modal>
    )
  }
}
