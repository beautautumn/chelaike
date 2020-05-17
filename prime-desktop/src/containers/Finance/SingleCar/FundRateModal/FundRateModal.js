import React, { Component, PropTypes } from 'react'
import { bindActionCreators } from 'redux'
import { connect } from 'react-redux'
import { show as showNotification } from 'redux/modules/notification'
import { updateFundRate as update, fetchFees } from 'redux/modules/finance/singleCar'
import { connectModal } from 'redux-modal'
import { Modal, Button } from 'antd'
import Form from './Form.js'

function fetchData({ store: { dispatch }, props: { record } }) {
  return dispatch(fetchFees(record.carId, 'fund_cost'))
}

@connectModal({ name: 'fundRateEidtforFinance', resolve: fetchData })
@connect(
  (state) => ({
    carFees: state.financeSingleCar.fees,
    saved: state.financeSingleCar.saved,
    saving: state.financeSingleCar.saving,
  }),
  dispatch => (
    bindActionCreators({
      update,
      fetchFees,
      showNotification,
    }, dispatch)
  )
)
export default class FundRateModal extends Component {
  static propTypes = {
    show: PropTypes.bool.isRequired,
    record: PropTypes.object.isRequired,
    handleHide: PropTypes.func.isRequired,
    showNotification: PropTypes.func.isRequired,
    saved: PropTypes.bool,
    saving: PropTypes.bool,
    carFees: PropTypes.array.isRequired,
    fetchFees: PropTypes.func.isRequired,
  }

  componentWillReceiveProps(nextProps) {
    if (!this.props.saved && nextProps.saved) {
      this.props.fetchFees(this.props.record.carId, 'fund_cost')
      this.props.showNotification({
        type: 'success',
        message: '保存成功',
      })
    }
  }

  handleReCompute = () => {
    if (!this.props.saving) {
      this.refs.form.submit()
    }
  }

  handleSubmit = (data) => {
    const { record, update } = this.props
    update(record.id, data)
  }

  render() {
    const { show, handleHide, record, carFees } = this.props

    const initialValues = {
      fundRate: record.fundRate,
      loanWan: record.loanWan,
    }

    return (
      <Modal
        title="资金利率调整"
        maskClosable={false}
        visible={show}
        onCancel={handleHide}
        width="800px"
        footer={[
          <Button key="back" type="ghost" size="large" onClick={handleHide}>关闭</Button>,
        ]}
      >
        <Form
          ref="form"
          carName={record.name}
          payment={record.paymentWan}
          stockAge={record.stockAgeDays}
          carFees={carFees}
          initialValues={initialValues}
          onSubmit={this.handleSubmit}
          handleReCompute={this.handleReCompute}
        />
      </Modal>
    )
  }
}
