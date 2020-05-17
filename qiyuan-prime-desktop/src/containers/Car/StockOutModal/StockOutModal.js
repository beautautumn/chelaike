import React, { Component, PropTypes } from 'react'
import { bindActionCreators } from 'redux'
import { connect } from 'react-redux'
import { show as showNotification } from 'redux/modules/notification'
import { create, update, fetch as fetchStockOutInventory } from 'redux/modules/stockOutInventories'
import { fetch as fetchCarRevervation } from 'redux/modules/carReservations'
import moment from 'moment'
import SalesForm from './SalesForm/SalesForm'
import AllianceForm from './AllianceForm/AllianceForm'
import AllianceRefundForm from './AllianceRefundForm/AllianceRefundForm'
import AcquisitionRefundForm from './AcquisitionRefundForm/AcquisitionRefundForm'
import DriveBackForm from './DriveBackForm/DriveBackForm'
import { connectModal } from 'redux-modal'
import { Modal, Tabs, Button } from 'antd'
import confirmIfTooBig from 'helpers/confirmIfTooBig'

const { TabPane } = Tabs

function fetchData({ store: { getState, dispatch }, props: { id, action } }) {
  const car = getState().entities.cars[id]
  if (action === 'edit') {
    return dispatch(fetchStockOutInventory(id))
  } else if (car.reserved) {
    return dispatch(fetchCarRevervation(id))
  }
}

@connectModal({ name: 'carStockOut', resolve: fetchData })
@connect(
  (state, { id }) => ({
    car: state.entities.cars[id],
    transfersById: state.entities.transfers,
    reservation: state.carReservations.currentReservation,
    stockOutInventory: state.stockOutInventories.currentStockOutInventory,
    currentUser: state.auth.user,
    enumValues: state.enumValues,
    saved: state.stockOutInventories.saved,
    saving: state.stockOutInventories.saving,
    error: state.stockOutInventories.error,
  }),
  dispatch => ({
    ...bindActionCreators({
      create,
      update,
      showNotification,
    }, dispatch)
  })
)
export default class StockOutModal extends Component {
  static propTypes = {
    show: PropTypes.bool.isRequired,
    car: PropTypes.object.isRequired,
    currentUser: PropTypes.object.isRequired,
    reservation: PropTypes.object,
    stockOutInventory: PropTypes.object,
    create: PropTypes.func.isRequired,
    update: PropTypes.func.isRequired,
    showNotification: PropTypes.func.isRequired,
    handleHide: PropTypes.func.isRequired,
    saved: PropTypes.bool,
    saving: PropTypes.bool,
    error: PropTypes.string,
    action: PropTypes.string,
    transfersById: PropTypes.object,
  }

  constructor(props) {
    super(props)

    this.state = {
      stockOutType: 'sold',
      showMicroContract: false,
    }
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
    if (!this.props.action && nextProps.action) {
      if (nextProps.action === 'edit') {
        this.setState({ stockOutType: nextProps.stockOutInventory.stockOutInventoryType })
      }
    }
  }

  handleSwitchType = value => {
    this.setState({ stockOutType: value })
  }

  handleOk = () => {
    if (!this.props.saving) {
      this.refs[`${this.state.stockOutType}Form`].submit()
    }
  }

  handleSubmit = (values) => {
    const { stockOutType, showMicroContract } = this.state
    if (stockOutType === 'alliance' && !showMicroContract) {
      this.setState({ showMicroContract: true })
      return
    }
    return new Promise((resolve, reject) => {
      confirmIfTooBig(values, [
        { key: 'closingCostWan', name: '成交价格', unit: '万元' },
        { key: 'depositWan', name: '定金', unit: '万元' },
        { key: 'carriedInterestWan', name: '成交分成', unit: '万元' },
        { key: 'remainingMoneyWan', name: '余款', unit: '万元' },
        { key: 'downPaymentWan', name: '首付款', unit: '万元' },
        { key: 'loanAmountWan', name: '贷款额度', unit: '万元' },
        { key: 'transferFeeYuan', name: '过户费用', unit: '元' },
        { key: 'commissionYuan', name: '佣金', unit: '元' },
        { key: 'invoiceFeeYuan', name: '开票费用', unit: '元' },
        { key: 'otherFeeYuan', name: '其他费用', unit: '元' },
      ], () => {
        const { car, action, create, update } = this.props
        const ret = action === 'edit' ? update(car.id, values) : create(car.id, values)
        ret.then(response => {
          if (response.error) {
            reject(response.error.errors.stockOutInventory)
          } else {
            resolve()
          }
        })
      })
    })
  }

  renderForms() {
    const {
      car,
      currentUser,
      action,
      reservation,
      stockOutInventory,
      transfersById,
    } = this.props

    const { showMicroContract } = this.state

    let salesInventory
    let allianceInventory
    let acquisitionRefundInventory
    let allianceRefundInventory
    let driveBackInventory

    if (action === 'edit') {
      salesInventory = { ...stockOutInventory }
      allianceInventory = { ...stockOutInventory }
      acquisitionRefundInventory = { ...stockOutInventory }
      allianceRefundInventory = { ...stockOutInventory }
      driveBackInventory = { ...stockOutInventory }
    } else {
      salesInventory = {
        paymentType: 'cash',
        salesType: 'retail',
        proxyInsurance: false,
        sellerId: currentUser.id,
        stockOutInventoryType: 'sold',
        completedAt: moment().format('YYYY-MM-DD'),
        refundedAt: moment().format('YYYY-MM-DD')
      }
      allianceInventory = {
        sellerId: currentUser.id,
        completedAt: moment().format('YYYY-MM-DD'),
        stockOutInventoryType: 'alliance',
      }
      allianceRefundInventory = {
        stockOutInventoryType: 'alliance_refunded',
        refundedAt: moment().format('YYYY-MM-DD'),
        refundedPriceWan: 0,

      }
      acquisitionRefundInventory = {
        stockOutInventoryType: 'acquisition_refunded'
      }

      driveBackInventory = {
        stockOutInventoryType: 'driven_back'
      }

      if (reservation) {
        [
          'salesType', 'customerChannelId', 'sellerId', 'closingCostWan', 'depositWan',
          'customerName', 'customerPhone', 'customerIdcard', 'customerLocationProvince',
          'customerLocationCity', 'customerLocationAddress', 'proxyInsurance',
          'insuranceCompanyId', 'commercialInsuranceFeeYuan', 'compulsoryInsuranceFeeYuan',
        ].forEach((key) => {
          if (reservation[key]) {
            salesInventory[key] = reservation[key]
          }
        })
      }
    }

    let showForms = []
    const forms = {
      sold: {
        title: '销售出库',
        component: (
          <SalesForm
            ref="soldForm"
            car={car}
            initialValues={salesInventory}
            onSubmit={this.handleSubmit}
            {...this.props}
          />
        ),
      },
      alliance: {
        title: '联盟出库',
        component: (
          <AllianceForm
            ref="allianceForm"
            car={car}
            transfersById={transfersById}
            initialValues={allianceInventory}
            onSubmit={this.handleSubmit}
            showMicroContract={showMicroContract}
            {...this.props}
          />
        )
      },
      acquisition_refunded: {
        title: '收购退车',
        component: (
          <AcquisitionRefundForm
            ref="acquisition_refundedForm"
            car={car}
            initialValues={acquisitionRefundInventory}
            onSubmit={this.handleSubmit}
            {...this.props}
          />
        )
      },
      alliance_refunded: {
        title: '联盟退车',
        component: (
          <AllianceRefundForm
            ref="alliance_refundedForm"
            car={car}
            initialValues={allianceRefundInventory}
            onSubmit={this.handleSubmit}
            {...this.props}
          />
        )
      },
      driven_back: {
        title: '车主开回',
        component: (
          <DriveBackForm
            ref="driven_backForm"
            car={car}
            initialValues={driveBackInventory}
            onSubmit={this.handleSubmit}
            {...this.props}
          />
        )
      }
    }

    if (action === 'edit') {
      showForms.push(stockOutInventory.stockOutInventoryType)
    } else {
      showForms.push('sold')
      showForms.push('alliance')
      if (car.acquisitionType !== 'consignment') {
        showForms.push('acquisition_refunded')
      }
      if (car.acquisitionType === 'consignment') {
        showForms.push('driven_back')
      }
      if (car.acquisitionType === 'alliance') {
        showForms.push('alliance_refunded')
      }
    }

    showForms = showForms.map((type) => (
      <TabPane tab={forms[type].title} key={type}>
        {forms[type].component}
      </TabPane>
    ))

    return (
      <Tabs defaultActiveKey={this.state.stockOutType} onChange={this.handleSwitchType}>
        {showForms}
      </Tabs>
    )
  }


  render() {
    const { show, handleHide } = this.props

    const { stockOutType, showMicroContract } = this.state

    const okText = stockOutType === 'alliance' && !showMicroContract ? '下一步' : '确定'

    const footer = [
      <Button key="close" type="ghost" size="large" onClick={handleHide}>取消</Button>,
    ]
    if (stockOutType === 'alliance' && showMicroContract) {
      footer.push((
        <Button
          key="preStep"
          type="ghost"
          size="large"
          onClick={() => this.setState({ showMicroContract: false })}
        >
          上一步
        </Button>
      ))
    }
    footer.push((
      <Button key="nextStep" type="primary" size="large" onClick={this.handleOk}>{okText}</Button>
    ))

    return (
      <Modal
        title="车辆出库"
        width="900px"
        maskClosable={false}
        visible={show}
        onCancel={handleHide}
        onOk={this.handleOk}
        footer={footer}
      >
        {this.renderForms()}
      </Modal>
    )
  }
}
