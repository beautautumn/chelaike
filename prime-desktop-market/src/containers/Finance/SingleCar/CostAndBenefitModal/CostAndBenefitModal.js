import React, { Component, PropTypes } from 'react'
import { bindActionCreators } from 'redux'
import { connect } from 'react-redux'
import { show as showNotification } from 'redux/modules/notification'
import { update, fetchFees } from 'redux/modules/finance/singleCar'
import { connectModal } from 'redux-modal'
import { Modal } from 'antd'
import Form from './Form.js'

const categoryOfFees = {
  payment: '入库付款',
  prepare_cost: '整备费用',
  handling_charge: '手续费用',
  commission: '佣金',
  percentage: '提成／分成',
  fund_cost: '资金成本',
  other_cost: '其它成本',
  receipt: '出库收款',
  other_profit: '其它收益',
}


function fetchData({ store: { dispatch }, props: { record, category } }) {
  return dispatch(fetchFees(record.carId, category))
}

@connectModal({ name: 'costAndBenefitEditForFinance', resolve: fetchData })
@connect(
  (state) => ({
    saved: state.financeSingleCar.saved,
    saving: state.financeSingleCar.saving,
    carFees: state.financeSingleCar.fees,
    enumValues: state.enumValues,
  }),
  dispatch => ({
    ...bindActionCreators({
      update,
      showNotification,
    }, dispatch)
  })
)
export default class CostAndBenefitModal extends Component {
  static propTypes = {
    show: PropTypes.bool.isRequired,
    record: PropTypes.object.isRequired,
    handleHide: PropTypes.func.isRequired,
    showNotification: PropTypes.func.isRequired,
    saved: PropTypes.bool,
    saving: PropTypes.bool,
    category: PropTypes.string.isRequired,
    carFees: PropTypes.array.isRequired,
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
    const { record, update, category } = this.props
    const carFees = data.carFees.map(fee => {
      const { indexForSort, ...rest } = fee // eslint-disable-line
      rest.amount = Number(rest.amount)
      rest.category = category
      return rest
    })
    update(record.carId, { carFees })
  }

  render() {
    const { record, show, handleHide, category, carFees, enumValues } = this.props

    const initialValues = { carFees }

    return (
      <Modal
        title={`调整${categoryOfFees[category]}`}
        maskClosable={false}
        visible={show}
        onCancel={handleHide}
        onOk={this.handleOk}
        width="800px"
      >
        <Form
          ref="form"
          record={record}
          category={category}
          initialValues={initialValues}
          onSubmit={this.handleSubmit}
          enumValues={enumValues}
        />
      </Modal>
    )
  }
}
