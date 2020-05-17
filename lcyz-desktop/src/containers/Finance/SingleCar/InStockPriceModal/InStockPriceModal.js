import React, { Component, PropTypes } from 'react'
import { bindActionCreators } from 'redux'
import { connect } from 'react-redux'
import { show as showNotification } from 'redux/modules/notification'
import { fetchEdit } from 'redux/modules/cars'
import { updateStockPrice as update } from 'redux/modules/finance/singleCar'
import { connectModal } from 'redux-modal'
import { Modal } from 'antd'
import Form from './Form.js'
import confirmIfTooBig from 'helpers/confirmIfTooBig'

function fetchData({ store: { dispatch }, props: { record } }) {
  return dispatch(fetchEdit(record.carId))
}

@connectModal({ name: 'inStockPriceEditForFinance', resolve: fetchData })
@connect(
  (state, { record }) => ({
    car: state.entities.cars[record.carId],
    saved: state.financeSingleCar.saved,
    saving: state.financeSingleCar.saving
  }),
  dispatch => ({
    ...bindActionCreators({
      update,
      showNotification,
    }, dispatch)
  })
)
export default class InStockPriceModal extends Component {
  static propTypes = {
    show: PropTypes.bool.isRequired,
    car: PropTypes.object.isRequired,
    handleHide: PropTypes.func.isRequired,
    showNotification: PropTypes.func.isRequired,
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
    const { record, update } = this.props

    const checkFields = [
      { key: 'acquisitionPrice', name: '入库价', unit: '万元' },
    ]

    confirmIfTooBig(data, checkFields, () => {
      update(record.id,
             { financeCarIncome: data, type: 'in_stock' })
    })
  }

  render() {
    const { car, show, handleHide } = this.props

    const initialValues = {
      shopId: car.shopId,
      acquirerId: car.acquirerId,
      acquiredAt: car.acquiredAt,
      acquisitionPriceWan: car.acquisitionPriceWan,
      note: ''
    }

    return (
      <Modal
        title="调整入库价"
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
