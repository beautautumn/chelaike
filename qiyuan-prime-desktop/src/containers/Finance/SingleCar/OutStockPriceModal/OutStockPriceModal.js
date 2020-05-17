import React, { Component, PropTypes } from 'react'
import { bindActionCreators } from 'redux'
import { connect } from 'react-redux'
import { show as showNotification } from 'redux/modules/notification'
import { fetch as fetchStockOutInventory } from 'redux/modules/stockOutInventories'
import { updateStockPrice as update } from 'redux/modules/finance/singleCar'
import { connectModal } from 'redux-modal'
import { Modal } from 'antd'
import Form from './Form.js'
import confirmIfTooBig from 'helpers/confirmIfTooBig'

function fetchData({ store: { dispatch }, props: { record } }) {
  return dispatch(fetchStockOutInventory(record.carId))
}

@connectModal({ name: 'outStockPriceEditForFinance', resolve: fetchData })
@connect(
  (state) => ({
    stockOutInventory: state.stockOutInventories.currentStockOutInventory,
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
export default class OutStockPriceModal extends Component {
  static propTypes = {
    show: PropTypes.bool.isRequired,
    stockOutInventory: PropTypes.object.isRequired,
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
      { key: 'closingCostWan', name: '成交价格', unit: '万元' },
      { key: 'depositWan', name: '定金', unit: '万元' },
      { key: 'remainingMoneyWan', name: '余款', unit: '万元' },
      { key: 'downPaymentWan', name: '首付款', unit: '万元' },
      { key: 'loanAmountWan', name: '贷款额度', unit: '万元' },
      { key: 'transferFeeYuan', name: '过户费用', unit: '元' },
      { key: 'commissionYuan', name: '佣金', unit: '元' },
      { key: 'invoiceFeeYuan', name: '开票费用', unit: '元' },
      { key: 'otherFeeYuan', name: '其他费用', unit: '元' },
      { key: 'mortgageFeeYuan', name: '按揭费用', unit: '元' },
      { key: 'foregiftYuan', name: '押金', unit: '元' },
    ]

    confirmIfTooBig(data, checkFields, () => {
      const { note, ...stockOutInventory } = data
      const financeCarIncome = { note, closingCostWan: stockOutInventory.closingCostWan }
      update(record.id,
             { financeCarIncome, stockOutInventory, type: 'out_stock' })
    })
  }

  render() {
    const { record, stockOutInventory, show, handleHide } = this.props

    const initialValues = { ...stockOutInventory, note: '' }

    return (
      <Modal
        title="调整出库价"
        maskClosable={false}
        visible={show}
        onCancel={handleHide}
        onOk={this.handleOk}
      >
        <Form
          ref="form"
          carName={record.name}
          initialValues={initialValues}
          onSubmit={this.handleSubmit}
        />
      </Modal>
    )
  }
}
