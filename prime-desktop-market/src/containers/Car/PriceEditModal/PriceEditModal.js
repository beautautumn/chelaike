import React, { Component, PropTypes } from 'react'
import { bindActionCreators } from 'redux'
import { connect } from 'react-redux'
import { show as showNotification } from 'redux/modules/notification'
import { create } from 'redux/modules/carPrices'
import { connectModal } from 'redux-modal'
import { Modal } from 'antd'
import Form from './PriceEditForm.js'
import pick from 'lodash/pick'
import confirmIfTooBig from 'helpers/confirmIfTooBig'

@connectModal({ name: 'carPriceEdit' })
@connect(
  (state, { id }) => ({
    car: state.entities.cars[id],
    saved: state.carPrices.saved,
    saving: state.carPrices.saving
  }),
  dispatch => ({
    ...bindActionCreators({
      create,
      showNotification,
    }, dispatch)
  })
)
export default class PriceEditModal extends Component {
  static propTypes = {
    show: PropTypes.bool.isRequired,
    car: PropTypes.object.isRequired,
    create: PropTypes.func.isRequired,
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
    const { car, create } = this.props

    const checkFields = [
      { key: 'showPriceWan', name: '展厅标价', unit: '万元' },
      { key: 'onlinePriceWan', name: '网络标价', unit: '万元' },
      { key: 'salesMinimunPriceWan', name: '销售底价', unit: '万元' },
      { key: 'managerPriceWan', name: '经理价', unit: '万元' },
      { key: 'allianceMinimunPriceWan', name: '联盟底价', unit: '万元' },
      { key: 'newCarGuidePriceWan', name: '新车指导价', unit: '万元' },
      { key: 'newCarAdditionalPriceWan', name: '新车加价', unit: '万元' },
      { key: 'newCarFinalPriceWan', name: '新车完税价', unit: '万元' },
    ]

    confirmIfTooBig(data, checkFields, () => {
      if (!data.allianceMinimunPriceWan) {
        data.allianceMinimunPriceWan = data.managerPriceWan
      }
      create(car.id, data)
    })
  }

  render() {
    const { car, show, handleHide } = this.props

    const price = pick(
      car,
      'showPriceWan',
      'onlinePriceWan',
      'salesMinimunPriceWan',
      'managerPriceWan',
      'allianceMinimunPriceWan',
      'redStockWarningDays',
      'yellowStockWarningDays',
      'newCarGuidePriceWan',
      'newCarAdditionalPriceWan',
      'newCarDiscount',
      'newCarFinalPriceWan',
    )

    return (
      <Modal
        title="销售定价"
        maskClosable={false}
        visible={show}
        onCancel={handleHide}
        onOk={this.handleOk}
      >
        <Form
          ref="form"
          car={car}
          initialValues={price}
          onSubmit={this.handleSubmit}
        />
      </Modal>
    )
  }
}
